require 'puppet/util/wildfly_cli'

Puppet::Type.type(:wildfly_cli).provide(:http_api) do

  # need to improve this
  def cli
    Puppet::Util::WildflyCli.new(@resource[:host], @resource[:port], @resource[:username], @resource[:password])
  end

  def exec(command)

    debug "Running: #{@resource[:command]}"
    cli.exec(@resource[:command])

  end

  def should_execute?
    condition, command = @resource[:unless].split /\sof\s/

    variable, operator, value = condition.sub('(', '').sub(')', '').split /\s/

    debug "Executing: #{command} to verify: (#{condition})"

    response = cli.exec(command)

    condition = "#{response[variable]} #{operator} #{value}"

    not eval(condition)
  end

end