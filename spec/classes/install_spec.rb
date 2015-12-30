require 'spec_helper'

describe 'wildfly::install' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'install wildfly' do
    let(:facts) {{ :operatingsystem           => 'CentOS' ,
                   :kernel                    => 'Linux',
                   :osfamily                  => 'RedHat',
                   :operatingsystemmajrelease => 7 }}

    it { should contain_class('wildfly::install') }
    it do
      should contain_exec('Download wildfly from http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz').with(
        'command'  => 'wget -N -P /var/cache/wget http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz --max-redirect=5',
        'creates'  => '/var/cache/wget/wildfly-9.0.2.Final.tar.gz',
      )
    end
  end
end
