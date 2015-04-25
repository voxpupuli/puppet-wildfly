require 'puppet/util/wildfly_cli'

Puppet::Type.type(:wildfly_cli).provide(:http_api) do
  def cli
    Puppet::Util::WildflyCli.instance(@resource[:host], @resource[:port], @resource[:username], @resource[:password])
  end

  def exec(command)
    debug "Running: #{command}"
    cli.exec(command)
  end

  def should_execute?
    unless_eval = true
    onlyif_eval = false

    unless @resource[:unless].nil?
      unless_eval = evaluate_command(@resource[:unless])
    end

    unless @resource[:onlyif].nil?
      onlyif_eval = evaluate_command(@resource[:onlyif])
    end

    onlyif_eval || !unless_eval
  end

  def evaluate_command(command)
    condition, command = command.split(/\sof\s/)
    variable, operator, value = condition.sub('(', '').sub(')', '').split(/\s/)

    debug "Executing: #{command} to verify: (#{condition})"

    response = cli.exec(command)

    condition = "'#{response[variable]}' #{operator} '#{value}'"

    debug "Condition (#{condition})"

    eval(condition)
  end
end
