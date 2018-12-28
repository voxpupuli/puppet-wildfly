require 'spec_helper'

describe 'wildfly::patch::online' do
  let(:facts) do
    { :operatingsystem => 'CentOS',
      :kernel => 'Linux',
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :initsystem => 'systemd',
      :fqdn => 'appserver.localdomain' }
  end

  let(:title) { '9.0.2' }
  let(:params) do
    { :source => '/opt/wildfly-9.0.2.patch' }
  end

  describe 'with defaults' do
    let(:pre_condition) { 'include wildfly' }

    it do
      is_expected.to contain_exec("Patch #{title}")
        .with(:command => "jboss-cli.sh -c 'patch apply /opt/wildfly-9.0.2.patch'",
              :unless  => "jboss-cli.sh -c 'patch history' | grep -q #{title}",
              :path    => ['/bin', '/usr/bin', '/sbin', '/opt/wildfly/bin'],
              :environment => 'JAVA_HOME=/usr/java/default')
        .that_requires('Service[wildfly]')
        .that_notifies("Wildfly::Restart[Restart for patch #{title}]")
    end
  end
end
