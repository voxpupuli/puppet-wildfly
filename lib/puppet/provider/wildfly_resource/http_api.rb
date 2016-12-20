# require 'puppet_x/wildfly/api_client'
# require 'puppet_x/wildfly/operation_request'

Puppet::Type.type(:wildfly_resource).provide(:http_api) do
  desc 'Uses JBoss HTTP API to manipulate a resource'

  confine :feature => :puppet_x_wildfly_api_client

  def cli
    api_client = PuppetX::Wildfly::APIClient.new(@resource[:host], @resource[:port], @resource[:username], @resource[:password])
    PuppetX::Wildfly::OperationRequest.new(api_client)
  end

  def create
    debug "Creating #{@resource[:path]} with state #{@resource[:state].inspect}"
    cli.add(@resource[:path], @resource[:state], @resource[:recursive], @resource[:operation_headers])
  end

  def destroy
    debug "Destroying #{@resource[:path]}"
    cli.remove(@resource[:path], @resource[:operation_headers])
  end

  def exists?
    debug "Exists? #{@resource[:path]}"
    cli.exists?(@resource[:path])
  end

  def state
    debug "Retrieve state: #{@resource[:path]}"
    cli.read(@resource[:path], @resource[:recursive])
  end

  def state=(value)
    debug "Updating state for: #{@resource[:path]} with #{@resource[:state].inspect}"
    cli.update(@resource[:path], value, @resource[:recursive], @resource[:operation_headers])
  end
end
