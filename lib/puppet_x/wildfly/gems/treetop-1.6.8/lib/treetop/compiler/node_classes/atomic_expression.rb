# frozen_string_literal: true

module Treetop
  module Compiler
    class AtomicExpression < ParsingExpression
      def inline_modules
        []
      end

      def single_quote(string)
        # Double any backslashes, then backslash any single-quotes:
        "'#{string.gsub(%r{\\}) { '\\\\' }.gsub(%r{'}) { "\\'" }}'"
      end
    end
  end
end
