require 'puppet_x/wildfly/api_client'
require 'puppet_x/wildfly/cli_command'

module PuppetX
  module Wildfly
    class OperationRequest
      def initialize(api_client)
        @api_client = api_client
      end

      def exec(command)
        @api_client.send(command)
      end

      def exists?(resource)
        command = "#{resource}:read-resource"
        response = @api_client.send(command, true)
        response['outcome'] == 'success'
      end

      def read(resource, recursive = false)
        command = "#{resource}:read-resource(recursive=#{recursive})"
        response = @api_client.send(command)
        response['outcome'] == 'success' ? response['result'] : {}
      end

      def add(resource, state)
        command = "#{resource}:add"
        detyped_request = CLICommand.new(command).to_detyped_request

        @api_client.send(detyped_request.merge(state), false, true)
      end

      def remove(resource)
        command = "#{resource}:remove"
        @api_client.send(command)
      end
    end
  end
end
