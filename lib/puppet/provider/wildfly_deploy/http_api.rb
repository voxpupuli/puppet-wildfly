require 'base64'
require 'puppet/util/wildfly_cli'

Puppet::Type.type(:wildfly_deploy).provide(:http_api) do

  # need to improve this
  def cli
    Puppet::Util::WildflyCLI.new(@resource[:host], @resource[:port], @resource[:username], @resource[:password])
  end

  def create
    cli.deploy(@resource[:name], @resource[:source])
  end

  def destroy
    cli.undeploy(@resource[:name])
  end

  def exists?
    cli.exists?("/deployment=#{@resource['name']}")
  end

  def content
    response = cli.read("/deployment=#{@resource['name']}")
    bytes_value = response['content'].first['hash']['BYTES_VALUE']
    decoded = Base64.decode64(bytes_value)

    decoded.unpack('H*').first
  end

  def content=(value)
    cli.undeploy(@resource[:name])
    cli.deploy(@resource[:name], @resource[:source])
  end

end