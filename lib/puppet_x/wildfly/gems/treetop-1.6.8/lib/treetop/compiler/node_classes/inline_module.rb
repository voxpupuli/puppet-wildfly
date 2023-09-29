# frozen_string_literal: true

module Treetop
  module Compiler
    module InlineModuleMixin
      attr_reader :module_name

      def compile(index, _builder, rule)
        @module_name = "#{rule.name.treetop_camelize}#{index}"
      end
    end

    class InlineModule < Runtime::SyntaxNode
      include InlineModuleMixin

      def compile(index, builder, rule)
        super
        builder.module_declaration(module_name) do
          builder << ruby_code.gsub(%r{\A\n}, '').rstrip
        end
      end

      def ruby_code
        elements[1].text_value
      end
    end
  end
end
