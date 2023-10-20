# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::setup' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let :pre_condition do
        'class { "wildfly": }'
      end

      context 'with default params' do
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
  end
end
