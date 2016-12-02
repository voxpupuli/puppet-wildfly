require 'puppet_x/wildfly/api_client'
require 'puppet_x/wildfly/operation_request'

Puppet::Type.type(:wildfly_cli).provide(:http_api) do
  desc 'Uses JBoss HTTP API to execute a JBoss-CLI command'

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
      unless_eval = evaluate_command(@resource[:unless])
    end

    unless @resource[:onlyif].nil?
      onlyif_eval = evaluate_command(@resource[:onlyif])
    end

    onlyif_eval || !unless_eval || (@resource[:unless].nil? && @resource[:onlyif].nil?)
  end

  def evaluate_command(command)
    condition, command = command.split(%r{\sof\s})
    variable, operator, value = condition.sub('(', '').sub(')', '').split(%r{\s})

    debug "Executing: #{command} to verify: (#{condition})"

    response = cli.exec(command, :ignore_failed_outcome => true)

    if operator == 'has'
      condition = "#{response[variable].inspect}.include?(#{value})"
    else
      condition = "'#{response[variable]}' #{operator} '#{value}'"
    end

    debug "Condition (#{condition})"

    eval(condition)
  end
end
