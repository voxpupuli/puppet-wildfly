# require 'puppet_x/wildfly/api_client'
# require 'puppet_x/wildfly/operation_request'

Puppet::Type.type(:wildfly_cli).provide(:http_api) do
  desc 'Uses JBoss HTTP API to execute a JBoss-CLI command'

  confine :feature => :puppet_x_wildfly_api_client

  def cli
    api_client = PuppetX::Wildfly::APIClient.new(@resource[:host], @resource[:port], @resource[:username], @resource[:password])
    PuppetX::Wildfly::OperationRequest.new(api_client)
  end

  def exec(command)
    debug "Running: #{command}"
    cli.exec(command)
  end

  def should_execute?
    unless_eval = true
    onlyif_eval = false

    unless @resource[:unless].nil?
      unless_eval = cli.evaluate(@resource[:unless])
    end

    unless @resource[:onlyif].nil?
      onlyif_eval = cli.evaluate(@resource[:onlyif])
    end

    onlyif_eval || !unless_eval || (@resource[:unless].nil? && @resource[:onlyif].nil?)
  end
end
