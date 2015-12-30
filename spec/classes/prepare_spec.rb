require 'spec_helper'

describe 'wildfly::prepare' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'add group, user, create home with default params' do
    let(:facts) {{ :operatingsystem           => 'CentOS' ,
                   :kernel                    => 'Linux',
                   :osfamily                  => 'RedHat',
                   :operatingsystemmajrelease => 7 }}

    it { should contain_class('wildfly::prepare') }
    it { should contain_group('wildfly') }
    it { should contain_user('wildfly') }
    it do
      should contain_file('/opt/wildfly').with(
        'ensure' => 'directory',
        'owner' => 'wildfly',
        'group' => 'wildfly',
        'mode' => '0755'
      )
    end
  end

  context 'install dependencies for Redhat' do
    let(:facts) {{ :operatingsystem           => 'CentOS' ,
                   :kernel                    => 'Linux',
                   :osfamily                  => 'RedHat',
                   :operatingsystemmajrelease => 7 }}

    it { should contain_package('libaio') }
  end

  context 'install dependencies for Debian' do
    let(:facts) {{ :operatingsystem           => 'Debian' ,
                   :kernel                    => 'Linux',
                   :osfamily                  => 'Debian',
                   :operatingsystemmajrelease => 10 }}
    it { should contain_package('libaio1') }
  end

end
