class Puppet::Provider::Wildfly < Puppet::Provider
  def cli
    require 'wildfly'

    timeout = @resource.parameters.include?(:timeout) ? resource[:timeout] : 60

    client = ::Wildfly::Client.new(@resource[:host], @resource[:port], @resource[:username], @resource[:password], timeout)
    ::Wildfly::OperationRequest.new(client)
  end
end
