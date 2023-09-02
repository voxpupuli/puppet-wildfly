require 'spec_helper_acceptance'

describe "Domain mode with #{test_data['distribution']}:#{test_data['version']} and custom server-group" do
  context 'Initial install Wildfly and verification' do
    it 'applies the manifest without error' do
      pp = <<-EOS
          class { 'wildfly':
            distribution   => '#{test_data['distribution']}',
            version        => '#{test_data['version']}',
            install_source => '#{test_data['install_source']}',
            java_home      => '#{test_data['java_home']}',
            java_opts      => '-Djava.net.preferIPv4Stack=true',
            mode           => 'domain',
            host_config    => 'host-master.xml',
          }

          wildfly::domain::server_group { 'app-server-group':
            profile              => 'full-ha',
            socket_binding_group => 'full-ha-sockets',
          }

          wildfly::deployment { 'hawtio.war':
            source       => 'https://repo1.maven.org/maven2/io/hawt/hawtio-web/1.4.66/hawtio-web-1.4.66.war',
            server_group => 'app-server-group',
          }

      EOS

      execute_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
      expect(execute_manifest(pp, :catch_failures => true).exit_code).to be_zero
      shell('sleep 25')
    end

    it 'service wildfly' do
      expect(service(test_data['service_name'])).to be_enabled
      expect(service(test_data['service_name'])).to be_running
    end

    it 'runs on port 9990' do
      expect(port(9990)).to be_listening
    end

    it 'protected management page' do
      shell('curl -v 127.0.0.1:9990/management 2>&1', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '401 Unauthorized'
      end
    end

    it 'is a Domain Controller' do
      shell("#{jboss_cli} 'ls'",
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'process-type=Domain Controller'
      end
    end

    # TODO it 'has hawtio deployed at app-server-group'
    it 'has hawtio deployed at app-server-group' do
      shell("#{jboss_cli} '/server-group=app-server-group/deployment=hawtio.war:read-resource'",
            :acceptable_exit_codes => 1) do |r|
        expect(r.stdout).to include 'success'
      end
    end
  end
end
