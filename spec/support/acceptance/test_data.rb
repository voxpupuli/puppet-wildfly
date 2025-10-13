def test_data
  RSpec.configuration.test_data
end

profile = ENV['TEST_profile'] || 'wildfly:9.0.2'

puts "Marcus war hier"
puts "Debug: Profile"
puts profile.inspect

data = {}

case profile
when /(wildfly):(\d{1,}\.\d{1,}\.\d{1,})/
  data['distribution']   = Regexp.last_match(1)
  data['version']        = Regexp.last_match(2)
  pkg_path = "wildfly/#{data['version']}.Final/wildfly-#{data['version']}.Final.tar.gz"
  data['install_source'] = (data['version'].to_f < 25.0 ? "http://download.jboss.org/#{pkg_path}" : "https://github.com/wildfly/#{pkg_path}")
  data['service_name']   = 'wildfly'

when /(jboss-eap):(\d{1,}\.\d{1,})/
  data['distribution']   = Regexp.last_match(1)
  data['version']        = Regexp.last_match(2)
  data['install_source'] = "http://10.0.2.2:9090/jboss-eap-#{data['version']}.tar.gz"
  data['service_name']   = (data['version'].to_f < 7.0 ? 'jboss-as' : 'jboss-eap')

when 'custom'
  data['distribution']   = ENV.fetch('TEST_distribution', 'wildfly')
  data['version']        = ENV.fetch('TEST_version', '9.0.2')
  data['install_source'] = ENV.fetch('TEST_install_source', "http://download.jboss.org/wildfly/#{data['version']}.Final/wildfly-#{data['version']}.Final.tar.gz")
  data['service_name']   = ENV.fetch('TEST_service_name', 'wildfly')
end

data['java_home'] = '/opt/jdk8u192-b12/'

RSpec.configuration.test_data = data

puts "Debug: Test-Data"
puts data.inspect

puts "Debug: Verfügbare Java-Version"
puts %x{ls -l /opt}
