require 'spec_helper'

describe 'wildfly', :type => :class do
  context 'with defaults for all parameters' do
    let(:facts) {{ :operatingsystem           => 'CentOS' ,
                   :kernel                    => 'Linux',
                   :osfamily                  => 'RedHat',
                   :operatingsystemmajrelease => 7 }}

    it { should contain_class('wildfly') }
    it { should contain_class('wildfly::prepare').that_comes_before('wildfly::install') }
    it { should contain_class('wildfly::install').that_comes_before('wildfly::setup') }
    it { should contain_class('wildfly::setup').that_comes_before('wildfly::service') }
    it { should contain_class('wildfly::service') }
  end
end
