require 'puppet_x/wildfly/api_client'
require 'puppet_x/wildfly/cli_command'

module PuppetX
  module Wildfly
    class OperationRequest
      def initialize(api_client)
        @api_client = api_client
  end

      def exec(command)
        detyped_request = CLICommand.new(command).to_detyped_request
        @api_client.send(detyped_request)
      end
    end
  end
end
