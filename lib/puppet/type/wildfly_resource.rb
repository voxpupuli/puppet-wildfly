Puppet::Type.newtype(:wildfly_resource) do
  @doc = 'Manages JBoss resources like datasources, messaging, ssl, modcluster, etc'

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:path, :namevar => true) do
    desc 'JBoss Resource Path'

    validate do |value|
      fail("Invalid resource path #{value}") unless value =~ %r{(\/[\w\-]+=[\w\-]+)}
    end
  end

  newparam(:username) do
    desc 'JBoss Management User'
  end

  newparam(:password) do
    desc 'JBoss Management User Password'
  end

  newparam(:host) do
    desc 'Host of Management API. Defaults to 127.0.0.1'
    defaultto '127.0.0.1'
  end

  newparam(:port) do
    desc 'Management port. Defaults to 127.0.0.1'
    defaultto 9990
  end

  newparam(:recursive) do
    desc 'Recursively manage resource. Defaults to false'
    defaultto false
  end

  newproperty(:state) do
    desc 'Resource state'
    defaultto {}

    validate do |value|
      value.is_a?(Hash)
    end

    def insync?(is)
      current_without_unused_keys = is.delete_if { |key, _| !should.keys.include? key }
      should.update(should){ |k,v| v.to_s }
      current_without_unused_keys.update(current_without_unused_keys){ |k,v| v.to_s }
      debug "Should: #{should.inspect} Is: #{current_without_unused_keys.inspect}"
      should.map(&:to_s).sort == current_without_unused_keys.map(&:to_s).sort
    end

    def change_to_s(current_value, new_value)
      changed_keys = (new_value.to_a - current_value.to_a).collect { |key, _|  key }

      current_value = current_value.delete_if { |key, _| !changed_keys.include? key }.inspect
      new_value = new_value.delete_if { |key, _| !changed_keys.include? key }.inspect

      super(current_value, new_value)
    end
  end

  autorequire(:service) do
    ['wildfly']
  end
end
