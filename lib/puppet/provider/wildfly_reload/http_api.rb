# require 'puppet_x/wildfly/api_client'
# require 'puppet_x/wildfly/operation_request'

Puppet::Type.type(:wildfly_reload).provide(:http_api) do
  desc 'Uses JBoss HTTP API to manage reloads.'

  confine :feature => :puppet_x_wildfly_api_client

  def cli
    api_client = PuppetX::Wildfly::APIClient.new(@resource[:host], @resource[:port], @resource[:username], @resource[:password])
    PuppetX::Wildfly::OperationRequest.new(api_client)
  end

  def reload
    debug 'Reloading...'

    cli.exec(':reload')

    retried = 0

    begin
      pending?
    rescue => e
      if retried + 1 < @resource[:retries].to_i
        retried += 1
        sleep @resource[:wait].to_i
        retry
      else
        raise e
      end
    end

    debug 'Reloaded!'
  end

  def pending?
    response = cli.exec(':read-attribute(name=server-state)')
    server_state = response['result']

    debug "Server state: #{server_state}"

    server_state == 'reload-required'
  end
end
