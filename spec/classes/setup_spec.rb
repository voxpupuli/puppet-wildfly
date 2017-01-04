require 'spec_helper'

describe 'wildfly::setup' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'with default params' do
    let(:facts) do
      { :operatingsystem => 'Debian',
        :kernel => 'Linux',
        :osfamily => 'Debian',
        :operatingsystemmajrelease => '8',
        :initsystem => 'systemd',
        :fqdn => 'appserver.localdomain' }
    end

    it do
      is_expected.to contain_file('/opt/wildfly/bin/standalone.conf')
        .with(:owner => 'wildfly',
              :group   => 'wildfly')
        .that_notifies('Service[wildfly]')
    end
    it do
      is_expected.to contain_file('/opt/wildfly/jboss.properties')
        .with(:owner => 'wildfly',
              :group   => 'wildfly')
        .that_notifies('Service[wildfly]')
    end
    it { is_expected.to contain_wildfly__config__mgmt_user('puppet') }
  end
end
