require 'spec_helper'

describe 'wildfly::install' do
  let :pre_condition do
    'class { "wildfly": }'
  end

  context 'install wildfly' do
    it { should contain_class('wildfly::install') }
    it do
      should contain_archive('/tmp/wildfly-8.2.0.Final.tar.gz').with(
        'extract' => true,
        'extract_path' => '/opt/wildfly',
        'creates' => '/opt/wildfly/jboss-modules.jar',
        'user' => 'wildfly',
        'group' => 'wildfly',
        'extract_flags' => '--strip-components=1 -zxf'
      )
    end
  end
end
