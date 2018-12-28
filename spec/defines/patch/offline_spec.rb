require 'spec_helper'

describe 'wildfly::patch::offline' do
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
        .with(:command => "jboss-cli.sh 'patch apply /opt/wildfly-9.0.2.patch'",
              :unless  => "jboss-cli.sh 'patch history' | grep -q #{title}",
              :path    => ['/bin', '/usr/bin', '/sbin', '/opt/wildfly/bin'],
              :environment => 'JAVA_HOME=/usr/java/default')
    end
  end
end
