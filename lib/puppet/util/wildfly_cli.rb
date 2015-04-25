require 'uri'
require 'net/http'
require 'puppet/external/net/http/digest_auth'
require 'cgi'
require 'json'
require 'puppet/util/wildfly_cli_assembler'

class Puppet::Util::WildflyCli

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

  def add(resource, state)
    body = {
        :address => assemble_address(resource),
        :operation => :add
    }

    body_with_state = body.merge(state)

    send(body_with_state)
    #
    # if response['response-headers']['operation-requires-reload']
    #   reload
    # end
    #
    # response
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

  def read(resource)
    body = {
        :address => assemble_address(resource),
        :operation => 'read-resource'
    }

    response = send(body, :ignore_outcome => true)
    response['outcome'] == 'success' ? response['result'] : {}
  end

  def update(resource, state)
    remove = {
        :address => assemble_address(resource),
        :operation => :remove
    }

    add = {
        :address => assemble_address(resource),
        :operation => :add
    }

    composite = {
        :address => [],
        :operation => :composite,
        :steps => [remove, add.merge(state)]
    }

    send(composite)
  end

  def exec(command)
    body = assemble_command(command)
    send(body)
  end

  def deploy(name, source)
    add = {
        :address => {:deployment => name},
        :operation => :add,
        :content => [:url => source]
    }

    deploy = {
        :address => {:deployment => name},
        :operation => :deploy
    }

    composite = {
        :address => [],
        :operation => :composite,
        :steps => [add, deploy]
    }

    send(composite)
  end

  def undeploy(name)
    remove = {
        :address => {:deployment => name},
        :operation => :remove
    }

    undeploy = {
        :address => {:deployment => name},
        :operation => :undeploy
    }

    composite = {
        :address => [],
        :operation => :composite,
        :steps => [undeploy, remove]
    }

    send(composite)
  end

  private

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

    puts "Sending request: #{body.to_json}"

    http_response = @http_client.request http_request

    response = JSON.parse(http_response.body)

    unless response['outcome'] == 'success' || ignore_outcome
        fail response['failure-description'].to_s
    end

    response
  end

end