require 'spec_helper_acceptance'

describe "Standalone mode with #{test_data['distribution']}:#{test_data['version']}" do
  context 'Initial install Wildfly and verification' do
    let(:jboss_cli) { "JAVA_HOME=#{test_data['java_home']} /opt/wildfly/bin/jboss-cli.sh --connect" }

    it 'applies the manifest without error' do
      pp = <<-EOS
          class { 'wildfly':
            distribution   => '#{test_data['distribution']}',
            version        => '#{test_data['version']}',
            install_source => '#{test_data['install_source']}',
            java_home      => '#{test_data['java_home']}',
          }

          wildfly::config::module { 'org.postgresql':
            source       => 'http://central.maven.org/maven2/org/postgresql/postgresql/9.3-1103-jdbc4/postgresql-9.3-1103-jdbc4.jar',
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
              'password'       => 'postgres'
            }
          }
          ->
          wildfly::cli { ':reload':
            onlyif => '(result == reload-required) of :read-attribute(name=server-state)',
          }

      EOS

      apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      shell('sleep 15')
    end

    it 'service wildfly' do
      expect(service(test_data['service_name'])).to be_enabled
      expect(service(test_data['service_name'])).to be_running
    end

    it 'runs on port 8080' do
      expect(port(8080)).to be_listening
    end

    it 'welcome page' do
      shell('curl localhost:8080', :acceptable_exit_codes => 0) do |r|
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
