require 'spec_helper'

describe 'wildfly::service' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'use RedHat init script' do
    let(:facts) do
      { operatingsystem: 'CentOS',
        kernel: 'Linux',
        osfamily: 'RedHat',
        operatingsystemmajrelease: 6 }
    end

    it { is_expected.to contain_file('/etc/default/wildfly.conf') }
    it { is_expected.to contain_file('/etc/init.d/wildfly') }
    it do
      is_expected.to contain_service('wildfly').with(
        'ensure'     => true,
        'hasrestart' => true,
        'hasstatus'  => true
      ).that_requires(['File[/etc/default/wildfly.conf]', 'File[/etc/init.d/wildfly]'])
    end
    it { is_expected.to contain_file('/etc/init.d/wildfly').with_source('/opt/wildfly/bin/init.d/wildfly-init-redhat.sh') }
  end

  context 'use RedHat systemd script' do
    let(:facts) do
      { operatingsystem: 'CentOS',
        kernel: 'Linux',
        osfamily: 'RedHat',
        operatingsystemmajrelease: 7 }
    end

    it { is_expected.to contain_file('/etc/default/wildfly.conf') }
    it { is_expected.to contain_file('/etc/init.d/wildfly') }
    it do
      is_expected.to contain_service('wildfly').with(
        'ensure'     => true,
        'hasrestart' => true,
        'hasstatus'  => true
      ).that_requires(['File[/etc/default/wildfly.conf]', 'File[/etc/init.d/wildfly]'])
    end
    it { is_expected.to contain_file('/etc/init.d/wildfly').with_source('/opt/wildfly/bin/init.d/wildfly-init-redhat.sh') }
    it { is_expected.to contain_file('/etc/systemd/system/wildfly.service') }
  end

  context 'use Debian script' do
    let(:facts) do
      { operatingsystem: 'Debian',
        kernel: 'Linux',
        osfamily: 'Debian',
        operatingsystemmajrelease: 10 }
    end

    it { is_expected.to contain_file('/etc/default/wildfly') }
    it { is_expected.to contain_file('/etc/init.d/wildfly') }
    it do
      is_expected.to contain_service('wildfly').with(
        'ensure'     => true,
        'enable'     => true,
        'hasrestart' => true,
        'hasstatus'  => true
      ).that_requires(['File[/etc/default/wildfly]', 'File[/etc/init.d/wildfly]'])
    end

    it { is_expected.to contain_file('/etc/init.d/wildfly').with_source('/opt/wildfly/bin/init.d/wildfly-init-debian.sh') }
  end
end
