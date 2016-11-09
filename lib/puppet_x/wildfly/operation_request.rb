require 'puppet_x/wildfly/api_client'
require 'puppet_x/wildfly/cli_command'
require 'puppet_x/wildfly/operation_builder'

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

      def exists?(resource)
        response = @api_client.send(operation.read(resource).build, true)
        response['outcome'] == 'success'
      end

      def read(resource, recursive = false)
        response = @api_client.send(operation.read(resource).with(:recursive => recursive).build)
        response['outcome'] == 'success' ? response['result'] : {}
      end

      def add(resource, state)
        @api_client.send(operation.add(resource).with(state).build)
      end

      def deploy(name, source, server_group)
        add_content = operation.add_content(name, source).build
        deploy = operation.target(server_group).deploy(name).build

        @api_client.send(operation.composite(add_content, deploy).build)
      end

			def undeploy(name, server_group)
				undeploy = operation.target(server_group).undeploy(name).build
				remove_content = operation.remove_content(name).build

				@api_client.send(operation.composite(undeploy, remove_content).build)
			end

			def update_deploy(name, source, server_group)
				undeploy = operation.target(server_group).undeploy(name).build
				remove_content = operation.remove_content(name).build

        add_content = operation.add_content(name, source).build
        deploy = operation.target(server_group).deploy(name).build

				@api_client.send(operation.composite(undeploy, remove_content, add_content, deploy).build)
			end

      def remove(resource)
        @api_client.send(operation.remove(resource).build)
      end

			def operation
				OperationBuilder.new	
			end
    end
  end
end
