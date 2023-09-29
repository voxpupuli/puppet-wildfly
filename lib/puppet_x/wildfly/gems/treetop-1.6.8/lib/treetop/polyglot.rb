# frozen_string_literal: true

module Treetop
  module Polyglot
    VALID_GRAMMAR_EXT = %w[treetop tt]
    VALID_GRAMMAR_EXT_REGEXP = %r{\.(#{VALID_GRAMMAR_EXT.join('|')})\Z}o
  end
end

require 'polyglot'
Polyglot.register(Treetop::Polyglot::VALID_GRAMMAR_EXT, Treetop)
