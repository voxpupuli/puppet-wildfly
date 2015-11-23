require 'spec_helper'

describe 'wildfly::install' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'install wildfly' do
    it { should contain_class('wildfly::install') }
    it do
      should contain_exec('curl http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz').with(
        'command'  => "/usr/bin/curl -s -S -L -o /tmp/wildfly-8.2.1.Final.tar.gz 'http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz'",
        'creates'  => "/tmp/wildfly-8.2.1.Final.tar.gz",
      )
    end
  end
end
