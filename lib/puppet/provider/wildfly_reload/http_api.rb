require File.expand_path(File.join(File.dirname(__FILE__), '..', 'wildfly'))

Puppet::Type.type(:wildfly_reload).provide :http_api, :parent => Puppet::Provider::Wildfly do
  desc 'Uses JBoss HTTP API to manage reloads.'

  def reload
    debug 'Reloading...'

    cli.exec(':reload')

    retried = 0

    begin
      pending?
    rescue => e
      raise e unless retried + 1 < @resource[:retries]
      retried += 1
      sleep @resource[:wait]
      retry
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
