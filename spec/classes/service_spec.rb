require 'spec_helper'

describe 'wildfly::service' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'use RedHat init script' do
    let(:facts) do
      { :operatingsystem => 'CentOS',
        :kernel => 'Linux',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '6',
        :initsystem => 'sysvinit' }
    end

    it { is_expected.to contain_class('wildfly::service::sysvinit') }

    it { is_expected.to contain_file('/etc/default/wildfly.conf') }
    it { is_expected.to contain_file('/etc/init.d/wildfly') }
    it do
      is_expected.to contain_service('wildfly').with(
        'ensure'     => true,
        'hasrestart' => true,
        'hasstatus'  => true
      )
    end
    it { is_expected.to contain_file('/etc/init.d/wildfly').with_source('/opt/wildfly/bin/init.d/wildfly-init-redhat.sh') }
  end

  context 'use RedHat systemd script' do
    let(:facts) do
      { :operatingsystem => 'CentOS',
        :kernel => 'Linux',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '7',
        :initsystem => 'systemd' }
    end

    it { is_expected.to contain_class('wildfly::service::systemd') }
    it { is_expected.to contain_file('/etc/default/wildfly.conf') }
    it { is_expected.to contain_file('/etc/init.d/wildfly') }
    it do
      is_expected.to contain_service('wildfly').with(
        'ensure'     => true,
        'hasrestart' => true,
        'hasstatus'  => true
      )
    end
    it { is_expected.to contain_file('/etc/init.d/wildfly').with_source('/opt/wildfly/bin/init.d/wildfly-init-redhat.sh') }
    it { is_expected.to contain_file('/etc/systemd/system/wildfly.service') }
  end

  context 'use Debian script' do
    let(:facts) do
      { :operatingsystem => 'Debian',
        :kernel => 'Linux',
        :osfamily => 'Debian',
        :operatingsystemmajrelease => '8',
        :initsystem => 'systemd' }
    end

    it { is_expected.to contain_class('wildfly::service::systemd') }
    it { is_expected.to contain_file('/etc/default/wildfly') }
    it { is_expected.to contain_file('/etc/init.d/wildfly') }
    it do
      is_expected.to contain_service('wildfly').with(
        'ensure'     => true,
        'enable'     => true,
        'hasrestart' => true,
        'hasstatus'  => true
      )
    end

    it { is_expected.to contain_file('/etc/init.d/wildfly').with_source('/opt/wildfly/bin/init.d/wildfly-init-debian.sh') }
  end
end
