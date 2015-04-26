require 'puppet/util/wildfly_cli'

Puppet::Type.type(:wildfly_resource).provide(:http_api) do
  def cli
    Puppet::Util::WildflyCli.instance(@resource[:host], @resource[:port], @resource[:username], @resource[:password])
  end

  def create
    debug "Creating #{@resource[:path]} with state #{@resource[:state].inspect}"
    cli.add(@resource[:path], @resource[:state])
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
    cli.read(@resource[:path])
  end

  def state=(value)
    debug "Updating state for: #{@resource[:path]} with #{@resource[:state].inspect}"
    cli.update(@resource[:path], value)
  end
end
