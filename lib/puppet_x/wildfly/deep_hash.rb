require 'puppet/property'

class DeepHash < Puppet::Property
  def deep_intersect(is, should)
    diff = {}

    is.each do |key, value|
      next if should[key].nil?
      if value.is_a? Hash
        diff[key] = deep_intersect(value, should[key])
      elsif should.keys.include? key
        diff[key] = value
      end
    end

    diff
  end

  def insync?(is)
    deep_intersect(is, should) == should
  end

  def change_to_s(current_value, new_value)
    changed_keys = (new_value.to_a - current_value.to_a).collect { |key, _| key }

    current_value = current_value.delete_if { |key, _| !changed_keys.include? key }.inspect
    new_value = new_value.delete_if { |key, _| !changed_keys.include? key }.inspect

    super(current_value, new_value)
  end
end
