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

      def add_recursive(resource, state)
        sub_resources, top_level_state = state.partition(&with_nested_hash)
        operations = []
        operations << operation.add(resource).for(top_level_state).build

        sub_resources.each { |sub_resource| operations << operation.add_child(sub_resource, resource).build }

        @api_client.send(operation.composite(*operations).build)
      end

      def with_nested_hash
        lambda { |_, value| value.is_a?(Hash) && !value.keys.empty? && value[value.keys.first].is_a?(Hash) }
      end

      def update(resource, state)
        current_state = read(resource)
        @api_client.send(operation.composite(*diff(current_state, state, resource)).build)
      end

      def update_recursive(resource, state)
        current_state = read(resource, true)

        sub_resources = Hash[state.select(&with_nested_hash)]
        top_level_state = state.reject(&with_nested_hash)

        current_sub_resources = Hash[current_state.select(&with_nested_hash)]
        current_top_level_state = current_state.reject(&with_nested_hash)

        updates = []

        updates.push(*diff(current_top_level_state, top_level_state, resource))
        updates.push(*nested_level_diff(current_sub_resources, sub_resources, resource))

        @api_client.send(operation.composite(*updates).build)
      end

      def diff(current_state, desired_state, resource)
        updates = []
        to_update = desired_state.reject { |key, value| value == current_state[key] }
        to_update.each { |attribute, value| updates << operation.write_attribute(resource, attribute, value).build }
        updates
      end

      def nested_level_diff(current_sub_resources, desired_sub_resources, resource)
        updates = []

        desired_sub_resources.each do |key, value|
          node_type = key
          node_name = value.keys.first

          current_state = current_sub_resources[node_type][node_name]
          desired_state = value[node_name]
          resource_name = "#{resource}/#{node_type}=#{node_name}"

          updates.push(*diff(current_state, desired_state, resource_name))
        end

        updates
      end

      def remove(resource)
        @api_client.send(operation.remove(resource).build)
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

      def operation
        OperationBuilder.new
      end
    end
  end
end
