def test_data
  # profile = ENV['TEST_profile'] || 'wildfly:9.0.2' # letzte funktionierend bekannte Version
  profile = ENV['TEST_profile'] || 'wildfly:37.0.1'

  puts "Marcus war hier"
  puts "Debug: Profile"
  puts profile.inspect

  data = {}

  case profile
  when /(wildfly):(\d{1,}\.\d{1,}\.\d{1,})/
    data['distribution']   = Regexp.last_match(1)
    data['version']        = Regexp.last_match(2)
    data['install_source'] = if data['version'].to_f < 25.0
                               puts "weniger als 25"
                               "http://download.jboss.org/wildfly/#{data['version']}.Final/wildfly-#{data['version']}.Final.tar.gz"
                             else
                               puts "neuer als 25"
                               "https://github.com/wildfly/wildfly/releases/download/#{data['version']}.Final/wildfly-#{data['version']}.Final.tar.gz"
                             end
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

  data['java_home'] = '/usr/lib/jvm/jre-17-openjdk'

  puts "Debug: Test-Data"
  puts data.inspect

  puts "Debug: Verfügbare Java-Version"
  puts `ls -l /opt`
  puts "Debug: Default Java Version"
  puts `java --version`
  puts "Debug: Java Home"
  puts `ls -l #{data['java_home']}`

  # RSpec.configuration.test_data = data # das ist kaputt  undefined method `test_data= for #<RSpec::Core::Configuration:0x00007fe97ad8f020 
  data
end
