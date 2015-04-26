require 'digest'

Puppet::Type.newtype(:wildfly_deploy) do
  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
  end

  newparam(:source) do
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

  newproperty(:content) do
    defaultto ''

    def insync?(is)
      should = sha1sum?(@resource[:source])
      debug "Should SHA1: #{should} IS SHA1: #{is}"
      should == is
    end

    def sha1sum?(source)
      source_path = source.sub('file:', '')
      if File.exist?(source_path)
        return Digest::SHA1.hexdigest(File.read(source_path))
      end
    end
  end

  autorequire(:service) do
    ['wildfly']
  end
end
