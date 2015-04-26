Puppet::Type.newtype(:wildfly_cli) do
  newparam(:command) do
  end

  newparam(:unless) do
  end

  newparam(:onlyif) do
  end

  newparam(:name) do
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

  newproperty(:executed) do
    defaultto true

    def retrieve
      !provider.should_execute?
    end

    def sync
      provider.exec(@resource[:command])
    end
  end

  autorequire(:service) do
    ['wildfly']
  end
end
