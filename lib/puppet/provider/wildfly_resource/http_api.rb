require 'puppet_x/wildfly/api_client'
require 'puppet_x/wildfly/operation_request'

Puppet::Type.type(:wildfly_resource).provide(:http_api) do
  desc 'Uses JBoss HTTP API to manipulate a resource'

  def cli
    api_client = PuppetX::Wildfly::APIClient.new(@resource[:host], @resource[:port], @resource[:username], @resource[:password])
    PuppetX::Wildfly::OperationRequest.new(api_client)
  end

  def create
    debug "Creating #{@resource[:path]} with state #{@resource[:state].inspect}"
    if @resource[:recursive]
      cli.add_recursive(@resource[:path], @resource[:state])
    else
      cli.add(@resource[:path], @resource[:state])
    end
  end

  def destroy
    debug "Destroying #{@resource[:path]}"
    cli.remove(@resource[:path])
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
    if @resource[:recursive]
      cli.update_recursive(@resource[:path], value)
    else
      cli.update(@resource[:path], value)
    end
  end
end
