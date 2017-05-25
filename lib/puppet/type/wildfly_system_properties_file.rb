require 'yaml'

Puppet::Type.newtype(:wildfly_system_properties_file) do
  @doc = 'Manages a JBoss system properties from a file'

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name) do
    desc 'Name of the resource'
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

  newparam(:source) do
    desc 'File source in URL format. (e.g. file:/tmp/myapp.yaml)'
  end

  autorequire(:service) do
    ['wildfly']
  end
end
