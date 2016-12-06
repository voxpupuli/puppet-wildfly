require 'spec_helper'

describe 'wildfly::config::app_user' do
  let(:pre_condition) { 'include wildfly' }

  let(:facts) do
    { :operatingsystem => 'CentOS',
      :kernel => 'Linux',
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :initsystem => 'systemd',
      :hostname => 'appserver' }
  end

  let(:title) { 'wildfly' }

  let(:params) do
    { :password => 'safepass' }
  end

  it do
    is_expected.to contain_wildfly__config__user('wildfly:ApplicationRealm')
      .with(:password => 'safepass',
            :file_name => 'application-users.properties')
  end
end
