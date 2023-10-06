# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::config::user' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include wildfly' }
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
  end
end
