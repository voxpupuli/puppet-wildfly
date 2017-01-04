require 'spec_helper'

describe 'wildfly::cli' do
  let(:facts) do
    { :operatingsystem => 'CentOS',
      :kernel => 'Linux',
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :initsystem => 'systemd',
      :fqdn => 'appserver.localdomain' }
  end

  let(:title) { '/subsystem=web:read-resource' }

  describe 'with defaults' do
    let(:pre_condition) { 'include wildfly' }

    it do
      is_expected.to contain_wildfly_cli(title)
        .with(:username => 'puppet',
              :host     => '127.0.0.1',
              :port     => '9990')
        .that_requires('Service[wildfly]')
    end
  end

  describe 'with overrided parameters' do
    let(:pre_condition) do
      <<-EOS
      class { 'wildfly':
        properties => {
          'jboss.bind.address.management' => '192.168.10.10',
          'jboss.management.http.port' => '10090',
        },
        mgmt_user  => {
          username => 'admin',
          password => 'safepassword',
        }
      }
    EOS
    end

    it do
      is_expected.to contain_wildfly_cli(title)
        .with(:username => 'admin',
              :password => 'safepassword',
              :host     => '192.168.10.10',
              :port     => '10090')
        .that_requires('Service[wildfly]')
    end
  end
end
