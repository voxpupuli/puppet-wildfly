require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

RSpec.configure do |c|
  c.add_setting :test_data, :default => {}

  project_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    puppet_module_install(:source => project_root, :module_name => 'wildfly')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--force', '--version', '4.2.0')
      on host, puppet('module', 'install', 'jethrocarr-initfact')
      on host, '/opt/puppetlabs/puppet/bin/gem install treetop net-http-digest_auth --no-ri --no-rdoc'
      on host, 'wget --header "Cookie: oraclelicense=accept-securebackup-cookie" -N -P /var/cache/wget http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz && tar -C /opt -zxvf /var/cache/wget/jdk-8u111-linux-x64.tar.gz'
    end
  end
end

def test_data
  RSpec.configuration.test_data
end

profile = ENV['profile'] || 'wildfly:9.0.2'

data = {}

case profile
when 'wildfly:8.0'
  data['distribution'], data['version'] = profile.split(':')
  data['install_source'] = 'http://download.jboss.org/wildfly/8.0.0.Final/wildfly-8.0.0.Final.tar.gz'
when 'wildfly:8.2.1'
  data['distribution'], data['version'] = profile.split(':')
  data['install_source'] = 'http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz'
when 'wildfly:9.0.2'
  data['distribution'], data['version'] = profile.split(':')
  data['install_source'] = 'http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz'
when 'wildfly:10.1.0'
  data['distribution'], data['version'] = profile.split(':')
  data['install_source'] = 'http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.tar.gz'
when 'jboss-eap:6.4'
  data['distribution'], data['version'] = profile.split(':')
  data['install_source'] = 'http://10.0.2.2:9090/jboss-eap-6.4.tar.gz'
when 'jboss-eap:7.0'
  data['distribution'], data['version'] = profile.split(':')
  data['install_source'] = 'http://10.0.2.2:9090/jboss-eap-7.0.tar.gz'
when 'custom'
  data['distribution'] = ENV['distribution']
  data['version'] = ENV['version']
  data['install_source'] = ENV['install_source']
end

data['java_home'] = '/opt/jdk1.8.0_111/'

RSpec.configuration.test_data = data
