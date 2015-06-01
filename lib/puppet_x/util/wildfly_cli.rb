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
          :operation => composite
        }

        all_resources = split_resources(resource, state)

        steps = split_resources.map({|(name, state)| add_body(resource_state)})

        body_with_steps = body.merge({:steps => steps})

        send(body_with_steps)
      end

      def add(resource, state)
        body_with_state = add_body(resource_state)

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

      def read(resource, recursive=false)
        body = {
          :address => assemble_address(resource),
          :operation => 'read-resource',
          :recursive => recursive
        }

        response = send(body, :ignore_outcome => true)
        response['outcome'] == 'success' ? response['result'] : {}
      end

      def update_recursive(resource, state)
        remove = {
          :address => assemble_address(resource),
          :operation => :remove
        }

        all_resources = split_resources(resource, state)

        steps = split_resources.map {|(name, state)| add_body(resource_state)}

        composite = {
          :address => [],
          :operation => :composite,
          :steps => [remove].concat(steps)
        }

        send(composite)
      end

      def update(resource, state)
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

      def deploy(name, source)
        composite = {
          :address => [],
          :operation => :composite,
          :steps => [add_content(name, source), deploy_operation(name)]
        }

        send(composite)
      end

      def undeploy(name)
        composite = {
          :address => [],
          :operation => :composite,
          :steps => [undeploy_operation(name), remove_content(name)]
        }

        send(composite)
      end

      def update_deploy(name, source)
        composite = {
          :address => [],
          :operation => :composite,
          :steps => [undeploy_operation(name), remove_content(name), add_content(name, source), deploy_operation(name)]
        }

        send(composite)
      end

      private

      def split_resources(name, state)
        child_hashes = state.filter {|k,v| v.is_a?(Hash)}
        child_resources = child_hashes.reduce {|resources, (k,v)| resources.concat(v.reduce {|r2,(k2,v2)| r2.concat(split_resources("#{name}/#{k}=#{k2}", v2))})}
        base_state = [name, state.filter {|k,v| v.is_a?(Hash)}]
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
        add = {
          :address => { :deployment => name },
          :operation => :add,
          :content => [:url => source]
        }
        add
      end

      def remove_content(name)
        remove = {
          :address => { :deployment => name },
          :operation => :remove
        }
        remove
      end

      def deploy_operation(name)
        deploy = {
          :address => { :deployment => name },
          :operation => :deploy
        }
        deploy
      end

      def undeploy_operation(name)
        undeploy = {
          :address => { :deployment => name },
          :operation => :undeploy
        }
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
