require 'puppet_x/util/wildfly_cli'
require 'yaml'

Puppet::Type.type(:wildfly_system_properties_file).provide(:http_api) do
  desc 'Uses JBoss HTTP API to configure system properties from a file'

  def cli
    PuppetX::Util::WildflyCli.new(@resource[:host], @resource[:port], @resource[:username], @resource[:password])
  end

  def properties
    YAML.load_file(@resource[:source])
  end

  def path(name)
    "/system-property=#{name}"
  end

  def create
    debug "Setting all properties in #{@resource[:source]}"
    add_or_update_properties
  end

  def destroy
    debug "Removing all properties in #{@resource[:source]}"
    remove_properties
  end

  def exists?
    debug "Exists? #{@resource[:source]}"
    all_properties_set?
  end

  private

  def all_properties_set?
    properties.each do |key, value|
      path = path(key)
      return false unless cli.exists?(path) && cli.read(path)['value'] == value
    end
    true
  end

  def remove_properties
    hash = properties
    hash.keys.each do |key|
      path = path(key)
      if cli.exists?(path)
        cli.remove(path)
      end
    end
    hash
  end

  def add_or_update_properties
    hash = properties
    hash.each do |key, value|
      path = path(key)
      state = {value: value}

      if not cli.exists?(path)
        cli.add(path, state)
      elsif cli.read(path) != key
        cli.update(path, state)
      end
    end
    hash
  end
end
