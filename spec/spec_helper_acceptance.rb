require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

RSpec.configure do |c|
  c.add_setting :test_data, :default => {}

  project_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    puppet_module_install(:source => project_root, :module_name => 'wildfly')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--force', '--version', '4.13.1')
      on host, puppet('module', 'install', 'jethrocarr-initfact')
      on host, puppet('resource', 'package', 'wget', 'ensure=installed')
      on host, 'wget --header "Cookie: oraclelicense=accept-securebackup-cookie" -N -P /var/cache/wget http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz && tar -C /opt -zxvf /var/cache/wget/jdk-8u111-linux-x64.tar.gz'
    end
  end
end

def test_data
  RSpec.configuration.test_data
end

profile = ENV['TEST_profile'] || 'wildfly:9.0.2'

data = {}

case profile

when /(wildfly):(\d{1,}\.\d{1,}\.\d{1,})/
  data['distribution'] = Regexp.last_match(1)
  data['version'] = Regexp.last_match(2)
  data['install_source'] = "http://download.jboss.org/wildfly/#{data['version']}.Final/wildfly-#{data['version']}.Final.tar.gz"
  data['service_name'] = 'wildfly'
when /(jboss-eap):(\d{1,}\.\d{1,})/
  data['distribution'] = Regexp.last_match(1)
  data['version'] = Regexp.last_match(2)
  data['install_source'] = "http://10.0.2.2:9090/jboss-eap-#{data['version']}.tar.gz"
  data['service_name'] = (data['version'].to_f < 7.0 ? 'jboss-as' : 'jboss-eap')
when 'custom'
  data['distribution'] = ENV['TEST_distribution']
  data['version'] = ENV['TEST_version']
  data['install_source'] = ENV['TEST_install_source']
  data['service_name'] = ENV['TEST_service_name']
end

data['java_home'] = '/opt/jdk1.8.0_111/'

RSpec.configuration.test_data = data
