# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let :pre_condition do
        'class { "wildfly": }'
      end

      if os_facts[:osfamily] == 'RedHat'
        context 'use RedHat init script' do
          let(:facts) do
            os_facts.merge(
              {
                :initsystem => 'sysvinit',
              }
            )
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
      end

      if os_facts[:osfamily] == 'Debian'
        context 'use Debian script' do
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
    end
  end
end
