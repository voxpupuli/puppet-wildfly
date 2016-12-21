module Puppet::Parser::Functions
  newfunction(:patch_args, :type => :rvalue) do |args|
    source = args[0]
    override_all = args[1]
    override = args[2]
    preserve = args[3]

    params = []
    params << source

    if override_all then
      params << '--override-all'
    else
      unless override.empty? then params << "--override=#{override.join(',')}" end
      unless preserve.empty? then params << "--preserve=#{preserve.join(',')}" end
    end

    params.join(" ")
  end
end
