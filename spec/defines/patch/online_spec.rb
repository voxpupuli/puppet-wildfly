# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::patch::online' do
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
            .with(:command => "jboss-cli.sh -c 'patch apply /opt/wildfly-9.0.2.patch'",
                  :unless  => "jboss-cli.sh -c 'patch history' | grep -q #{title}",
                  :path    => ['/bin', '/usr/bin', '/sbin', '/opt/wildfly/bin'],
                  :environment => 'JAVA_HOME=/usr/java/default')
            .that_requires('Service[wildfly]')
            .that_notifies("Wildfly::Restart[Restart for patch #{title}]")
        end
      end
    end
  end
end
