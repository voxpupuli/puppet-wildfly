require 'puppet/provider/wildfly'

Puppet::Type.type(:wildfly_restart).provide :http_api, :parent => Puppet::Provider::Wildfly do
  desc 'Uses JBoss HTTP API to manage restarts.'

  def restart
    debug 'Restarting...'

    cli.exec(':shutdown(restart=true)')

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

    debug 'Restarted!'
  end

  def pending?
    response = cli.exec(':read-attribute(name=server-state)')
    server_state = response['result']

    debug "Server state: #{server_state}"

    server_state == 'restart-required'
  end
end
