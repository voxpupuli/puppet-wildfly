require 'spec_helper'

describe 'wildfly::setup' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'with default params' do
    let(:facts) {{ :operatingsystem           => 'Debian' ,
                   :kernel                    => 'Linux',
                   :osfamily                  => 'Debian',
                   :operatingsystemmajrelease => 10 }}

    it { should contain_file('/opt/wildfly/bin/standalone.conf') }
  end
end
