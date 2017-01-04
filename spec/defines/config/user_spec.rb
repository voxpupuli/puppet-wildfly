require 'spec_helper'

describe 'wildfly::config::user' do
  let(:pre_condition) { 'include wildfly' }

  let(:facts) do
    { :operatingsystem => 'CentOS',
      :kernel => 'Linux',
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :initsystem => 'systemd',
      :hostname => 'appserver' }
  end

  let(:title) { 'wildfly:ManagementRealm' }

  let(:params) do
    { :password  => 'safepass',
      :file_name => 'mgmt-users.properties' }
  end

  it do
    is_expected.to contain_file_line(title)
      .with(:path => '/opt/wildfly/standalone/configuration/mgmt-users.properties',
            :line => 'wildfly=76cfbe638ea42545686593864689fb85',
            :match => '^wildfly=.*$')
      .that_notifies('Service[wildfly]')
  end
end
