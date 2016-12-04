require 'spec_helper'

describe 'wildfly::install' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'install wildfly' do
    let(:facts) do
      { :operatingsystem => 'CentOS',
        :kernel => 'Linux',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '7',
        :initsystem => 'systemd' }
    end

    it { is_expected.to contain_class('wildfly::install') }
    it do
      is_expected.to contain_exec('Download wildfly from http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz').with(
        'command' => 'wget -N -P /var/cache/wget http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz --max-redirect=5',
        'creates' => '/var/cache/wget/wildfly-9.0.2.Final.tar.gz'
      )
    end
    it do
      is_expected.to contain_exec('untar wildfly-9.0.2.Final.tar.gz').with(
        'command' => 'tar --no-same-owner --no-same-permissions --strip-components=1 -C /opt/wildfly -zxvf /var/cache/wget/wildfly-9.0.2.Final.tar.gz',
        'creates' => '/opt/wildfly/jboss-modules.jar'
      )
    end
  end
end
