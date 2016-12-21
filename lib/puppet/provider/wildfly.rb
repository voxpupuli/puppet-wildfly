class Puppet::Provider::Wildfly < Puppet::Provider

  def cli
    require 'puppet_x/wildfly/api_client'
    require 'puppet_x/wildfly/operation_request'
    api_client = PuppetX::Wildfly::APIClient.new(@resource[:host], @resource[:port], @resource[:username], @resource[:password])
    PuppetX::Wildfly::OperationRequest.new(api_client)
  end

end
