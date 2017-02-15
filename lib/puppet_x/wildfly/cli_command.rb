require 'treetop'
require 'puppet_x/wildfly/jboss_cli'

module PuppetX
  module Wildfly
    class CLICommand
      def initialize(command)
        parser = JBossCLIParser.new
        @syntax_node = parser.parse(command)
      end

      def address
        address_to_key_value_list(@syntax_node.elements[0])
      end

      def operation
        operation = @syntax_node.elements[2]
        operation.empty? ? '' : operation.text_value
      end

      def params
        params_to_key_value_list(@syntax_node.elements[3])
      end

      def headers
        params_to_key_value_list(@syntax_node.elements[4])
      end

      def address_to_key_value_list(node)
        list = []

        unless node.empty?
          nodes = node.elements

          nodes.size.times do |index|
            element = nodes[index]
            list << { element.elements[1].text_value => element.elements[3].text_value.delete('"') }
          end
        end

        list
      end

      def params_to_key_value_list(node)
        list = []

        unless node.empty?
          nodes = node.elements[1].elements

          nodes.size.times do |index|
            element = nodes[index].elements[0]

            list << { element.elements[0].text_value => element.elements[2].text_value }
          end
        end

        list
      end

      def to_detyped_request
        request = {}
        request[:operation] = operation
        request[:address] = address

        params.each do |param|
          param.each do |key, value|
            request[key] = value
          end
        end

        unless headers.empty?
          request['operation-headers'] = {}
          headers.each do |header|
            header.each do |key, value|
              request['operation-headers'].store(key, value)
            end
          end
        end

        request
      end
    end
  end
end
