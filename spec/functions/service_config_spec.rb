# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::service_config' do
  context 'Wildfly 10 and newer' do
    let(:distribution) { 'wildfly' }
    let(:version) { '10.0' }

    let(:facts) do
      { :os => { :family => 'RedHat' } }
    end

    it 'using systemd' do
      is_expected.to run.with_params(distribution, version, 'standalone').and_return('service_name' => 'wildfly', 'conf_file' => '/etc/wildfly/wildfly.conf', 'conf_template' => 'wildfly/wildfly.systemd.conf', 'service_file' => 'docs/contrib/scripts/init.d/wildfly-init-redhat.sh', 'systemd_template' => 'wildfly/wildfly.systemd.service')
    end
  end

  context 'JBoss EAP 7 and newer' do
    let(:distribution) { 'jboss-eap' }
    let(:version) { '7.0' }

    it 'using systemd' do
      is_expected.to run.with_params(distribution, version, 'standalone').and_return('service_file' => 'bin/init.d/jboss-eap-rhel.sh', 'conf_file' => '/etc/default/jboss-eap.conf', 'service_name' => 'jboss-eap', 'conf_template' => 'wildfly/wildfly.systemd.conf', 'systemd_template' => 'wildfly/jboss-eap.systemd.service')
    end
  end
end
