class Hash
  def deep_stringify_values
    deep_transform_values(&:to_s)
  end

  def deep_obfuscate_sensitive_values
    _deep_transform_values_in_object(self, true, &:to_s)
  end

  def deep_transform_values(&block)
    _deep_transform_values_in_object(self, &block)
  end

  def _deep_transform_values_in_object(object, obfuscate = false, &block)
    case object
    when Hash
      object.inject({}) do |result, (key, value)|
        actual_block = obfuscate && key.include?('password') ? proc { |_| '******' } : block
        result[key] = _deep_transform_values_in_object(value, obfuscate, &actual_block)
        result
      end
    when Array
      object.map { |e| _deep_transform_values_in_object(e, obfuscate, &block) }.sort
    else
      yield(object)
    end
  end

  def deep_intersect(other)
    diff = {}
    managed_keys = other.keys

    each do |key, value|
      if value.is_a? Hash
        other_nested_hash = other[key]
        unless other_nested_hash.nil?
          diff[key] = value.deep_intersect(other_nested_hash)
        end
      elsif managed_keys.include? key
        diff[key] = value
      end
    end

    diff
  end

  def insync?(other)
    other.deep_intersect(self).deep_stringify_values == deep_stringify_values
  end
end
