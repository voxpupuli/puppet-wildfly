# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'install wildfly default version' do
        let :pre_condition do
          'class { "wildfly": }'
        end

        it { is_expected.to contain_class('wildfly::install') }
        it { is_expected.to contain_file('/var/cache/wget').with('ensure' => 'directory') }
        it do
          is_expected.to contain_file('/var/cache/wget/wildfly-9.0.2.Final.tar.gz').with(
            'source' => 'http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz',
          )
        end
        it do
          is_expected.to contain_exec('untar wildfly-9.0.2.Final.tar.gz').with(
            'command' => 'tar --no-same-owner --no-same-permissions --strip-components=1 -C /opt/wildfly -zxvf /var/cache/wget/wildfly-9.0.2.Final.tar.gz',
            'creates' => '/opt/wildfly/jboss-modules.jar',
          )
        end
      end

      context 'install wildfly 25' do
        let :pre_condition do
          "class { 'wildfly':
            version => '25.0.0',
          }"
        end

        it { is_expected.to contain_class('wildfly::install') }
        it { is_expected.to contain_file('/var/cache/wget').with('ensure' => 'directory') }
        it do
          is_expected.to contain_file('/var/cache/wget/wildfly-25.0.0.Final.tar.gz').with(
            'source' => 'https://github.com/wildfly/wildfly/releases/download/25.0.0.Final/wildfly-25.0.0.Final.tar.gz',
          )
        end
        it do
          is_expected.to contain_exec('untar wildfly-25.0.0.Final.tar.gz').with(
            'command' => 'tar --no-same-owner --no-same-permissions --strip-components=1 -C /opt/wildfly -zxvf /var/cache/wget/wildfly-25.0.0.Final.tar.gz',
            'creates' => '/opt/wildfly/jboss-modules.jar',
          )
        end
      end

      context 'install wildfly from package' do
        let :pre_condition do
          "class { 'wildfly':
            package_name    => 'wildfly',
            package_version => '10.1.0',
          }"
        end

        it { is_expected.to contain_class('wildfly::install') }
        it { is_expected.to contain_package('wildfly').with('ensure' => '10.1.0') }
      end

      context 'install wildfly from RHEL subscription', if: os_facts[:os]['name'] == 'RedHat' do
        let :pre_condition do
          "class { 'wildfly':
            package_name    => 'jboss-eap7',
            dnf_group_install => true,
          }"
        end

        it { is_expected.to contain_class('wildfly::install') }
        it { is_expected.to contain_yum__group('jboss-eap7').with('timeout' => 600).with('install_options' => []) }
      end
    end
  end
end
