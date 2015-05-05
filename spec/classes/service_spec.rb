require 'spec_helper'

describe 'wildfly::service' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'use RedHat script' do
    let :facts do
      {
        osfamily: 'Redhat'
      }
    end
    it { should contain_file('/etc/default/wildfly.conf') }
    it { should contain_file('/etc/init.d/wildfly') }
    it do
      should contain_service('wildfly').with(
        'ensure'     => true,
        'enable'     => true,
        'hasrestart' => true,
        'hasstatus'  => true
      ).that_requires(['File[/etc/default/wildfly.conf]', 'File[/etc/init.d/wildfly]'])
    end
    it { should contain_file('/etc/init.d/wildfly').with_source('/opt/wildfly/bin/init.d/wildfly-init-redhat.sh') }
  end

  context 'use Debian script' do
    let :facts do
      {
        osfamily: 'Debian'
      }
    end
    it { should contain_file('/etc/default/wildfly') }
    it { should contain_file('/etc/init.d/wildfly') }
    it do
      should contain_service('wildfly').with(
        'ensure'     => true,
        'enable'     => true,
        'hasrestart' => true,
        'hasstatus'  => true
      ).that_requires(['File[/etc/default/wildfly]', 'File[/etc/init.d/wildfly]'])
    end

    it { should contain_file('/etc/init.d/wildfly').with_source('/opt/wildfly/bin/init.d/wildfly-init-debian.sh') }
  end
end
