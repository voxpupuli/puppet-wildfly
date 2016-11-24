require 'spec_helper'

describe 'wildfly', type: :class do
  context 'with defaults for all parameters' do
    let(:facts) do
      { operatingsystem: 'CentOS',
        kernel: 'Linux',
        osfamily: 'RedHat',
        operatingsystemmajrelease: '7',
        initsystem: 'systemd' }
    end

    it { is_expected.to contain_class('wildfly') }
    it { is_expected.to contain_class('wildfly::prepare').that_comes_before('wildfly::install') }
    it { is_expected.to contain_class('wildfly::install').that_comes_before('wildfly::setup') }
    it { is_expected.to contain_class('wildfly::setup').that_comes_before('wildfly::service') }
    it { is_expected.to contain_class('wildfly::service') }
  end
end
