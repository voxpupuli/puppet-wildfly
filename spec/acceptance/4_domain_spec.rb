require 'spec_helper_acceptance'

describe "Domain mode with #{test_data['distribution']}:#{test_data['version']}" do
  context 'Initial install Wildfly and verification' do
    let(:jboss_cli) { "JAVA_HOME=#{test_data['java_home']} /opt/wildfly/bin/jboss-cli.sh --connect" }

    it 'applies the manifest without error' do
      pp = <<-EOS
          class { 'wildfly':
            distribution   => '#{test_data['distribution']}',
            version        => '#{test_data['version']}',
            install_source => '#{test_data['install_source']}',
            java_home      => '#{test_data['java_home']}',
            mode           => 'domain',
            host_config    => 'host-master.xml',
          }

          wildfly::resource { '/subsystem=datasources/data-source=ExampleDS':
            ensure  => absent,
            profile => 'full-ha',
          }

          wildfly::resource { '/profile=full/subsystem=datasources/data-source=ExampleDS':
            ensure  => absent,
          }

          wildfly::deployment { 'hawtio.war':
            source       => 'http://central.maven.org/maven2/io/hawt/hawtio-web/1.4.66/hawtio-web-1.4.66.war',
            server_group => 'main-server-group',
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

    it 'runs on port 9990' do
      expect(port(9990)).to be_listening
    end

    it 'protected management page' do
      shell('curl -v localhost:9990/management 2>&1', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '401 Unauthorized'
      end
    end

    it 'ExampleDS does not exists in full-ha profile' do
      shell("#{jboss_cli} '/profile=full-ha/subsystem=datasources/data-source=ExampleDS:read-resource'",
            :acceptable_exit_codes => 1) do |r|
        expect(r.stdout).to include 'not found'
      end
    end

    it 'ExampleDS does not exists in full profile' do
      shell("#{jboss_cli} '/profile=full-ha/subsystem=datasources/data-source=ExampleDS:read-resource'",
            :acceptable_exit_codes => 1) do |r|
        expect(r.stdout).to include 'not found'
      end
    end

    it 'is a Domain Controller' do
      shell("#{jboss_cli} 'ls'",
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'process-type=Domain Controller'
      end
    end
  end
end
