Puppet::Type.newtype(:wildfly_resource) do
  @doc = 'Manages JBoss resources like datasources, messaging, ssl, modcluster, etc'

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:path) do
    desc 'JBoss Resource Path'

    isnamevar

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

    isnamevar
  end

  newparam(:port) do
    desc 'Management port. Defaults to 127.0.0.1'
    defaultto 9990

    munge do |value|
      value.to_i
    end

    isnamevar
  end

  newparam(:recursive) do
    desc 'Recursively manage resource. Defaults to false'
    defaultto false
  end

  newparam(:operation_headers) do
    desc 'Operation headers.'
    defaultto {}

    validate do |value|
      raise("#{value} is not a Hash") unless value.is_a?(Hash)
    end
  end


  def self.title_patterns
    identity = lambda {|x| x}
    [
      [
        /^(.*):(.*):(.*)$/,
        [
          [ :path, identity ],
          [ :host, identity ],
          [ :port, identity ]
        ]
      ],
      [
        /^(.*):(.*)$/,
        [
            [ :path, identity ],
            [ :host, identity ],
        ]
      ],
      [
        /^([^:]+)$/,
        [
          [ :path, identity ]
        ]
      ]
    ]
  end

  newproperty(:state) do
    desc 'Resource state'
    defaultto {}

    validate do |value|
      raise("#{value} is not a Hash") unless value.is_a?(Hash)
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
    def transform_hash(original, &block)
      original.inject({}) do |result, (key, value)|
        value = if value.is_a?(Hash)
                  transform_hash(value, &block)
                else
                  value
                end
        yield(result, key, value)
        result
      end
    end

    # Helper function to transform values to strings
    def stringify_values(hash)
      transform_hash(hash) do |inner_hash, key, value|
        inner_hash[key] = value.is_a?(Hash) ? value : value.to_s
      end
    end

    def obfuscate_sensitive_data(hash)
      transform_hash(hash) do |inner_hash, key, value|
        inner_hash[key] = key.include?('password') ? '******' : value
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
end
