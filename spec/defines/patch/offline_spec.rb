# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::patch::offline' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { '9.0.2' }
      let(:params) do
        { :source => '/opt/wildfly-9.0.2.patch' }
      end

      context 'with defaults' do
        let(:pre_condition) { 'include wildfly' }

        it do
          is_expected.to contain_exec("Patch #{title}")
            .with(:command => "jboss-cli.sh 'patch apply /opt/wildfly-9.0.2.patch'",
                  :unless  => "jboss-cli.sh 'patch history' | grep -q #{title}",
                  :path    => ['/bin', '/usr/bin', '/sbin', '/opt/wildfly/bin'],
                  :environment => 'JAVA_HOME=/usr/java/default')
        end
      end
    end
  end
end
