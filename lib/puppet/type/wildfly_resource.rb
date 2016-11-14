Puppet::Type.newtype(:wildfly_resource) do
  @doc = 'Manages JBoss resources like datasources, messaging, ssl, modcluster, etc'

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:path, :namevar => true) do
    desc 'JBoss Resource Path'

    validate do |value|
      raise("Invalid resource path #{value}") unless value =~ %r{(\/[\w\-]+=[\w\-]+)}
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

  newparam(:operation_headers) do
    desc 'Operation headers.'
    defaultto {}

    validate do |value|
      value.is_a?(Hash)
    end
  end

  newproperty(:state) do
    desc 'Resource state'
    defaultto {}

    validate do |value|
      value.is_a?(Hash)
    end

    def recursive_sort!(obj)
      case obj
      when Array
        obj.map! { |v| recursive_sort!(v) }.sort_by { |v| (v.to_s rescue nil) }
      when Hash
        obj = Hash[Hash[obj.map { |k, v| [recursive_sort!(k), recursive_sort!(v)] }].sort_by { |k, v| [(k.to_s rescue nil), (v.to_s rescue nil)] }]
      else
        obj
      end
    end

    # Helper function to transform the hash
    def transform_hash(original, options = {}, &block)
      original.inject({}) do |result, (key, value)|
        value = if options[:deep] && Hash === value
                  transform_hash(value, options, &block)
                else
                  value
                end
        yield(result, key, value)
        result
      end
    end

    # Helper function to transform values to strings
    def stringify_values(hash)
      transform_hash(hash, :deep => true) do |hash, key, value|
        hash[key] = if value.is_a? Numeric
                      value.to_s
                    elsif value.is_a?(TrueClass) || value.is_a?(FalseClass)
                      value.to_s
                    else
                      value
                    end
      end
    end

    def obfuscate_sensitive_data(hash)
      transform_hash(hash, :deep => true) do |hash, key, value|
        if key.include?('password')
          hash[key] = '******'
        else
          hash[key] = value
        end
      end
    end

    # Return a hash containing the keys of the left hash that are also present in the right hash
    def state_diff(is, should)
      diff = {}
      managed_keys = should.keys

      is.each do |key, value|
        if value.is_a? Hash
          should_nested_hash = should[key]
          unless should_nested_hash.nil?
            diff[key] = state_diff(value, should_nested_hash)
          end
        elsif managed_keys.include? key
          diff[key] = value
        end
      end

      diff
    end

    def insync?(is)
      current_without_unused_keys = state_diff(is, should)

      debug "Should: #{stringify_values(recursive_sort!(should)).inspect} Is: #{stringify_values(recursive_sort!(current_without_unused_keys)).inspect}"

      stringify_values(recursive_sort!(should)) == stringify_values(recursive_sort!(current_without_unused_keys))
    end

    def change_to_s(current_value, new_value)
      changed_keys = (new_value.to_a - current_value.to_a).collect { |key, _| key }

      current_value = obfuscate_sensitive_data(current_value).delete_if { |key, _| !changed_keys.include? key }.inspect
      new_value = obfuscate_sensitive_data(new_value).delete_if { |key, _| !changed_keys.include? key }.inspect

      super(current_value, new_value)
    end
  end

  autorequire(:service) do
    ['wildfly']
  end
end
