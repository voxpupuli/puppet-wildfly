require 'spec_helper'

describe 'wildfly::prepare' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'add group, user, create home with default params' do
    let(:facts) do
      { :operatingsystem => 'CentOS',
        :kernel => 'Linux',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '7',
        :initsystem => 'systemd' }
    end

    it { is_expected.to contain_class('wildfly::prepare') }
    it { is_expected.to contain_group('wildfly') }
    it { is_expected.to contain_user('wildfly') }
    it do
      is_expected.to contain_file('/opt/wildfly').with(
        'ensure' => 'directory',
        'owner' => 'wildfly',
        'group' => 'wildfly',
        'mode' => '0755'
      )
    end
  end

  context 'install dependencies for Redhat' do
    let(:facts) do
      { :operatingsystem => 'CentOS',
        :kernel => 'Linux',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '7',
        :initsystem => 'systemd' }
    end

    it { is_expected.to contain_package('libaio') }
    it { is_expected.to contain_package('wget') }
  end

  context 'install dependencies for Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian',
        :kernel => 'Linux',
        :osfamily => 'Debian',
        :operatingsystemmajrelease => '8',
        :initsystem => 'systemd' }
    end
    it { is_expected.to contain_package('libaio1') }
    it { is_expected.to contain_package('wget') }
  end
end
