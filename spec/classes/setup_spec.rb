require 'spec_helper'

describe 'wildfly::setup' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'with default params' do
    let(:facts) do
      { operatingsystem: 'Debian',
        kernel: 'Linux',
        osfamily: 'Debian',
        operatingsystemmajrelease: 10 }
    end

    it { is_expected.to contain_file('/opt/wildfly/bin/standalone.conf') }
  end
end
