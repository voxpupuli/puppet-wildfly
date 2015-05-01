require 'spec_helper'

describe 'wildfly::setup' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'with default params' do
    it { should contain_exec('replace memory parameters') }
    it { should contain_wildfly__config__interfaces('public') }
    it { should contain_wildfly__config__interfaces('management') }
    it { should contain_wildfly__config__socket_binding('management-http') }
    it { should contain_wildfly__config__socket_binding('management-https') }
    it { should contain_wildfly__config__socket_binding('http') }
    it { should contain_wildfly__config__socket_binding('https') }
    it { should contain_wildfly__config__socket_binding('ajp') }
  end
end
