# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::prepare' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let :pre_condition do
        'class { "wildfly": }'
      end

      context 'add group, user, create home with default params' do
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

      if os_facts[:osfamily] == 'RedHat'
        context 'install dependencies for Redhat' do
          it { is_expected.to contain_package('libaio') }
        end
      end

      if os_facts[:osfamily] == 'Debian'
        context 'install dependencies for Debian' do
          it { is_expected.to contain_package('libaio1') }
        end
      end

      context 'do not managed WILDFLY_HOME with package installation' do
        let :pre_condition do
          "class { 'wildfly':
            package_name    => 'wildfly',
            package_version => '10.1.0',
          }"
        end

        it { is_expected.not_to contain_file('/opt/wildfly') }
      end

      context 'over-riding user_home' do
        let :pre_condition do
          "class { 'wildfly':
            user_home => '/opt/wildfly'
          }"
        end

        it do
          is_expected.to contain_user('wildfly')
            .with_home('/opt/wildfly')
        end
      end
    end
  end
end
