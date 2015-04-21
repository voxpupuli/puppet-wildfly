require 'puppet/util/wildfly_cli'

Puppet::Type.type(:wildfly_resource).provide(:http_api) do

  # need to improve this
  def cli
    Puppet::Util::WildflyCLI.new(@resource[:host], @resource[:port], @resource[:username], @resource[:password])
  end

  def create
    cli.add(@resource[:path], @resource[:state])
  end

  def destroy
    cli.remove(@resource[:path])
  end

  def exists?
    cli.exists?(@resource[:path])
  end

  def state
    cli.read(@resource[:path])
  end

  def state=(value)
    cli.remove(@resource[:path])
    cli.add(@resource[:path], value)
  end

end