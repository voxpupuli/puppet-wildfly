require 'spec_helper'

describe 'wildfly::setup' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'with default params' do
    it { should contain_file('/opt/wildfly/bin/standalone.conf') }
  end
end
