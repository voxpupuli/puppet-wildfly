require 'spec_helper_acceptance'

describe "Standalone mode with #{test_data['distribution']}:#{test_data['version']}" do
  context 'Initial install Wildfly and verification' do
    it 'applies the manifest without error' do
      pp = <<-EOS
          class { 'wildfly':
            distribution   => '#{test_data['distribution']}',
            version        => '#{test_data['version']}',
            install_source => '#{test_data['install_source']}',
            java_home      => '#{test_data['java_home']}',
            java_opts      => '-Djava.net.preferIPv4Stack=true',
          }

          wildfly::config::module { 'org.postgresql':
          # TODO
          # Error: /Stage[main]/Main/Wildfly::Deployment[hawtio.war]/File[/opt/hawtio-web-1.4.66.war]: Could not evaluate: Could not retrieve file metadata for http://central.maven.org/maven2/io/hawt/hawtio-web/1.4.66/hawtio-web-1.4.66.war: Request to http://central.maven.org/maven2/io/hawt/hawtio-web/1.4.66/hawtio-web-1.4.66.war failed after 0.02 seconds: Failed to open TCP connection to central.maven.org:80 (getaddrinfo: Name or service not known)
            source       => '#{test_data['postgres_jar_source']}',
            dependencies => ['javax.api', 'javax.transaction.api']
          }
          ->
          wildfly::datasources::driver { 'Driver postgresql':
            driver_name                     => 'postgresql',
            driver_module_name              => 'org.postgresql',
            driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource'
          }
          ->
          wildfly::datasources::datasource { 'DemoDS':
            config         => {
              'driver-name'    => 'postgresql',
              'connection-url' => 'jdbc:postgresql://localhost/postgres',
              'jndi-name'      => 'java:jboss/datasources/DemoDS',
              'user-name'      => 'postgres',
              'password'       => 'postgres',
              'jta'            => true,
              'min-pool-size'  => 15,
              'max-pool-size'  => 30,
            }
          }
          ->
          wildfly::cli { ':reload':
            onlyif => '(result == reload-required) of :read-attribute(name=server-state)',
          }


          wildfly::resource { '/subsystem=ee' :
            content => {
              'global-modules' => [{
                  'name' => 'org.bouncycastle',
                  'slot' => 'main'
              },
              {
                  'name' => 'org.joda.time',
                  'slot' => 'main'
              }
              ]
            }
          }
      EOS

      puts "Debug: Applying this Manifest from #{__FILE__}"
      puts pp
      apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      shell('sleep 25')
    end

    it 'service wildfly' do
      expect(service(test_data['service_name'])).to be_enabled
      expect(service(test_data['service_name'])).to be_running
    end

    it 'runs on port 8080' do
      expect(port(8080)).to be_listening
    end

    it 'welcome page' do
      shell('curl 127.0.0.1:8080', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'Welcome'
      end
    end

    it 'contains postgresql module' do
      shell('ls -la /opt/wildfly/modules/system/layers/base/org/postgresql/main', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'postgresql-9.3-1103-jdbc4.jar'
        expect(r.stdout).to include 'module.xml'
      end
    end

    it 'postgresql driver exists' do
      shell("#{jboss_cli} '/subsystem=datasources/jdbc-driver=postgresql:read-resource'",
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"outcome" => "success"'
      end
    end

    it 'datasource exists' do
      shell("#{jboss_cli} '/subsystem=datasources/data-source=DemoDS:read-resource'",
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"outcome" => "success"'
      end
    end

    it 'datasource is enabled' do
      shell("#{jboss_cli} '/subsystem=datasources/data-source=DemoDS:read-attribute(name=enabled)'",
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"result" => true'
      end
    end
  end
end
