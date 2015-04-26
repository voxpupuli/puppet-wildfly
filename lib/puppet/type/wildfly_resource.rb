require 'puppet/util/wildfly_cli'

Puppet::Type.newtype(:wildfly_resource) do
  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:path, :namevar => true) do
    validate do |value|
      fail("Invalid resource path #{value}") unless value =~ %r{(\/[\w\-]+=[\w\-]+)}
    end
  end

  newparam(:username) do
  end

  newparam(:password) do
  end

  newparam(:host) do
    defaultto '127.0.0.1'
  end

  newparam(:port) do
    defaultto 9990
  end

  newproperty(:state) do
    defaultto {}

    validate do |value|
      value.is_a?(Hash)
    end

    def insync?(is)
      current_without_unused_keys = is.delete_if { |key, value| !should.keys.include? key }
      debug "Should: #{should.inspect} Is: #{current_without_unused_keys.inspect}"
      should.to_a.sort == current_without_unused_keys.to_a.sort
    end

    def change_to_s(current_value, new_value)
      changed_keys = (new_value.to_a - current_value.to_a).collect { |key, value|  key }

      current_value = current_value.delete_if { |key, value| !changed_keys.include? key }.inspect
      new_value = new_value.delete_if { |key, value| !changed_keys.include? key }.inspect

      super(current_value, new_value)
    end
  end

  autorequire(:service) do
    ['wildfly']
  end
end
