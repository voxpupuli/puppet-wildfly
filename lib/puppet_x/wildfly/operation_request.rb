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

      def add(resource, state, recursive, headers)
        @api_client.send(operation.add(resource).with(state).headers(headers).build)
      end

      def update(resource, state, recursive, headers)
        current_state = read(resource)
        @api_client.send(operation.composite(*diff(current_state, state, resource).headers(headers)).build)
      end

      def diff(current_state, desired_state, resource)
        to_update = desired_state.reject { |key, value| value == current_state[key] }
        to_update.map { |attribute, value| operation.write_attribute(resource, attribute, value).build }
      end

      def remove(resource, headers)
        @api_client.send(operation.remove(resource).headers(headers).build)
      end

      def deploy(name, source, server_group, headers)
        @api_client.send(operation.composite(*deploy_operations(name, source, server_group)).headers(headers).build)
      end

      def deploy_operations(name, source, server_group)
        [operation.add_content(name, source).build, operation.target(server_group).deploy(name).build]
      end

      def undeploy(name, server_group, headers)
        @api_client.send(operation.composite(*undeploy_operations(name, server_group)).headers(headers).build)
      end

      def undeploy_operations(name, server_group)
        [operation.target(server_group).undeploy(name).build, operation.remove_content(name).build]
      end

      def update_deploy(name, source, server_group, headers)
        @api_client.send(operation.composite(*update_deploy_operations(name, source, server_group)).headers(headers).build)
      end

      def update_deploy_operations(name, source, server_group)
        undeploy_operations(name, server_group).push(*deploy_operations(name, source, server_group))
      end

      def operation
        OperationBuilder.new
      end
    end
  end
end
