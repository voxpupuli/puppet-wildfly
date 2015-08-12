require 'uri'
require 'net/http'
require 'cgi'
require 'json'
require 'puppet_x/util/wildfly_cli_assembler'
require 'puppet_x/util/digest_auth'

module PuppetX
  module Util
    class WildflyCli
      include WildflyCliAssembler

      @@instance = nil

      def initialize(address, port, user, password)
        @uri = URI.parse "http://#{address}:#{port}/management"
        @uri.user = CGI.escape(user)
        @uri.password = CGI.escape(password)

        @http_client = Net::HTTP.new @uri.host, @uri.port
      end

      def self.instance(address, port, user, password)
        if @@instance.nil?
          @@instance = new(address, port, user, password)
        end

        @@instance
      end

      def add_recursive(resource, state)
        body = {
          :address => [],
          :operation => :composite
        }

        all_resources = split_resources(resource, state)

        steps = all_resources.map { |(name, state)| add_body(name, state) }

        body_with_steps = body.merge(:steps => steps)

        send(body_with_steps)
      end

      def add(resource, state)
        body_with_state = add_body(resource, state)

        send(body_with_state)
      end

      def remove(resource)
        body = {
          :address => assemble_address(resource),
          :operation => :remove
        }

        send(body)
      end

      def exists?(resource)
        body = {
          :address => assemble_address(resource),
          :operation => 'read-resource'
        }

        response = send(body, :ignore_outcome => true)
        response['outcome'] == 'success'
      end

      def read(resource, recursive = false)
        body = {
          :address => assemble_address(resource),
          :operation => 'read-resource',
          :recursive => recursive
        }

        response = send(body, :ignore_outcome => true)
        response['outcome'] == 'success' ? response['result'] : {}
      end

      def update_recursive(resource, state, merge = false)
        if merge
          old_state = read(resource, true)
          state = recursive_merge_state(old_state, state)
        end

        remove = {
          :address => assemble_address(resource),
          :operation => :remove
        }

        all_resources = split_resources(resource, state)

        steps = all_resources.map { |(name, state)| add_body(name, state) }

        composite = {
          :address => [],
          :operation => :composite,
          :steps => [remove].concat(steps)
        }

        send(composite)
      end

      def update(resource, state, merge = false)
        if merge
           state = read(resource).merge(state)
        end

        remove = {
          :address => assemble_address(resource),
          :operation => :remove
        }

        add = add_body(resource, state)

        composite = {
          :address => [],
          :operation => :composite,
          :steps => [remove, add]
        }

        send(composite)
      end

      def exec(command)
        body = assemble_command(command)
        send(body)
      end

      def deploy(name, source, server_group)
        composite = {
          :address => [],
          :operation => :composite,
          :steps => [add_content(name, source), deploy_operation(name, server_group)]
        }

        unless server_group.nil?
          add = {
            :address => [{ 'server-group' => server_group }, { :deployment => name }],
            :operation => :add
          }
          composite[:steps].insert(1, add)
        end

        send(composite)
      end

      def undeploy(name, server_group)
        composite = {
          :address => [],
          :operation => :composite,
          :steps => [undeploy_operation(name, server_group), remove_content(name)]
        }

        unless server_group.nil?
          remove = {
            :address => [{ 'server-group' => server_group }, { :deployment => name }],
            :operation => :remove
          }
          composite[:steps].insert(1, remove)
        end

        send(composite)
      end

      def update_deploy(name, source, server_group)
        composite = {
          :address => [],
          :operation => :composite,
          :steps => [undeploy_operation(name, server_group), remove_content(name), add_content(name, source), deploy_operation(name, server_group)]
        }

        unless server_group.nil?
          remove = {
            :address => [{ 'server-group' => server_group }, { :deployment => name }],
            :operation => :remove
          }
          composite[:steps].insert(1, remove)

          add = {
            :address => [{ 'server-group' => server_group }, { :deployment => name }],
            :operation => :add
          }
          composite[:steps].insert(4, add)

        end

        send(composite)
      end

      private

      def recursive_merge_state(old_state, new_state)
        map_list = new_state.map do |k,v|
          if v.is_a?(Hash) and old_state.fetch(k, nil).is_a?(Hash)
            { k => recursive_merge_state(old_state[k], v) }
          else
            { k => v }
          end
        end
        old_state.reject {|k,v| v == nil}.merge(Hash[map_list])
      end

      def split_resources(name, state)
        # Ruby 1.8.7 Hash doesn't have filter
        child_hashes = state.reject { |k, v| !v.is_a?(Hash) }
        child_resources = child_hashes.reduce([]) { |resources, (k, v)| resources.concat(v.reduce([]) { |r2, (k2, v2)| r2.concat(split_resources("#{name}/#{k}=#{k2}", v2)) }) }
        base_state = [name, state.reject { |k, v| v.is_a?(Hash) }]
        [base_state].concat(child_resources)
      end

      def add_body(resource, state)
        body = {
          :address => assemble_address(resource),
          :operation => :add
        }

        body.merge(state)
      end

      def add_content(name, source)
        {
          :address => { :deployment => name },
          :operation => :add,
          :content => [:url => source]
        }
      end

      def remove_content(name)
        {
          :address => { :deployment => name },
          :operation => :remove
        }
      end

      def deploy_operation(name, server_group)
        deploy = {
          :address => { :deployment => name },
          :operation => :deploy
        }

        unless server_group.nil?
          deploy[:address] = [{ 'server-group' => server_group }, deploy[:address]]
        end

        deploy
      end

      def undeploy_operation(name, server_group)
        undeploy = {
          :address => { :deployment => name },
          :operation => :undeploy
        }

        unless server_group.nil?
          undeploy[:address] = [{ 'server-group' => server_group }, undeploy[:address]]
        end

        undeploy
      end

      def authz_header
        digest_auth = Net::HTTP::DigestAuth.new
        authz_request = Net::HTTP::Get.new @uri.request_uri
        response = @http_client.request authz_request
        digest_auth.auth_header @uri, response['www-authenticate'], 'POST'
      end

      def send(body, ignore_outcome = false)
        http_request = Net::HTTP::Post.new @uri.request_uri
        http_request.add_field 'Content-type', 'application/json'
        http_request.add_field 'Authorization', authz_header
        http_request.body = body.to_json

        http_response = @http_client.request http_request

        response = JSON.parse(http_response.body)

        unless response['outcome'] == 'success' || ignore_outcome
          fail "Failed with: #{response['failure-description']} for #{body.to_json}"
        end

        response
      end
    end
  end
end
