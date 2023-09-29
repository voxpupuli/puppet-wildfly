# frozen_string_literal: true

require 'spec_helper_acceptance'
require 'json'

describe "Deployment on standalone mode with #{test_data['distribution']}:#{test_data['version']}" do
  context 'Initial install Wildfly, deployment and verification' do
    it 'applies the manifest without error' do
      pp = <<-EOS
          class { 'wildfly':
            distribution   => '#{test_data['distribution']}',
            version        => '#{test_data['version']}',
            install_source => '#{test_data['install_source']}',
            java_home      => '#{test_data['java_home']}',
            java_opts      => '-Djava.net.preferIPv4Stack=true',
          }

          wildfly::deployment { 'hawtio.war':
            source => 'http://central.maven.org/maven2/io/hawt/hawtio-web/1.4.66/hawtio-web-1.4.66.war'
          }

          wildfly::deployment { 'sample.war':
            source => 'http://central.maven.org/maven2/org/codehaus/cargo/simple-war/1.6.2/simple-war-1.6.2.war'
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

    it 'runs on port 8080' do
      expect(port(8080)).to be_listening
    end

    it 'welcome page' do
      shell('curl 127.0.0.1:8080', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'Welcome'
      end
    end

    it 'downloaded WAR file' do
      shell('ls -la /opt/hawtio-web-1.4.66.war', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '/opt/hawtio-web-1.4.66.war'
      end
    end

    it 'deployed application' do
      shell("#{jboss_cli} '/deployment=hawtio.war:read-resource(recursive=true)'",
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"outcome" => "success"'
      end
      shell('curl 127.0.0.1:8080/'.concat('hawtio/'), :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'hawtio'
      end
    end
  end
end
