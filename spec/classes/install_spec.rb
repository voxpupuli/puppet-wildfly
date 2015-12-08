require 'spec_helper'

describe 'wildfly::install' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'install wildfly' do
    it { should contain_class('wildfly::install') }
    it do
      should contain_exec('Download wildfly from http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz').with(
        'command'  => 'wget -N -P /var/cache/wget http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz --max-redirect=5',
        'creates'  => '/var/cache/wget/wildfly-8.2.1.Final.tar.gz',
      )
    end
  end
end
