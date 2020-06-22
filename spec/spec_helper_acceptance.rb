require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'beaker/testmode_switcher/dsl'

module JBossCLI extend RSpec::Core::SharedContext
                let(:jboss_cli) { "JAVA_HOME=#{test_data['java_home']} /opt/wildfly/bin/jboss-cli.sh --connect" }
end

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

def install_with_dependencies(host)
  copy_module_to(host, :source => PROJECT_ROOT, :module_name => 'wildfly')

  on host, puppet('module', 'install', 'puppetlabs-stdlib', '--force', '--version', '4.13.1')
  on host, puppet('module', 'install', 'jethrocarr-initfact')
end

def install_wget(host)
  on host, puppet('resource', 'package', 'wget', 'ensure=installed')
end

RSpec.configure do |c|
  c.include JBossCLI
  c.add_setting :test_data, :default => {}
  c.formatter = :documentation
  c.before :suite do
    run_puppet_install_helper

    master = find_at_most_one_host_with_role(hosts, 'master')

    if master.nil?
      hosts.each do |host|
        install_with_dependencies(host)
        install_wget(host)
      end
    else
      install_with_dependencies(master)

      on master, 'yum install -y puppetserver'
      on master, 'echo "*" > /etc/puppetlabs/puppet/autosign.conf'
      on master, puppet('resource', 'service', 'firewalld', 'ensure=stopped', 'enable=false')
      on master, puppet('resource', 'service', 'puppetserver', 'ensure=running', 'enable=true')

      puppet_server_fqdn = fact_on('master', 'fqdn')

      hosts.agents.each do |agent|
        install_wget(agent)

        config = {
          'main' => {
            'server' => puppet_server_fqdn.to_s
          }
        }

        configure_puppet(config)
      end
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

data['java_home'] = '/usr/lib/jvm/jre-1.8.0-openjdk'

RSpec.configuration.test_data = data
