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

  data['java_home'] = `readlink /etc/alternatives/java`.gsub(%r{bin/java$}, '').strip
  data['postgres_jar_source'] = "https://repo1.maven.org/maven2/org/postgresql/postgresql/9.3-1103-jdbc41/postgresql-9.3-1103-jdbc41.jar"
  data['sample_war_simple'] = "https://repo1.maven.org/maven2/org/codehaus/cargo/simple-war/1.6.2/simple-war-1.6.2.war"
  data['sample_war_hawtio'] = "https://repo1.maven.org/maven2/io/hawt/hawtio-web/1.4.66/hawtio-web-1.4.66.war"
  data['beaker_autoconfigure'] = "true"

  puts "Debug: Test-Data"
  puts data.inspect

  puts "Debug: Java-Verison mit ganzem Pfad"
  puts `#{data['java_home']}/bin/java --version`

  # RSpec.configuration.test_data = data # das ist kaputt  undefined method `test_data= for #<RSpec::Core::Configuration:0x00007fe97ad8f020 
  data
end
