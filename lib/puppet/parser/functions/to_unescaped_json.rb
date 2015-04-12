require 'json'

module Puppet::Parser::Functions
  newfunction(:to_unescaped_json, :type => :rvalue) do |args|
    args[0].to_json.inspect
  end
end
