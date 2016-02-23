require 'spec_helper_acceptance'
require 'json'

describe 'Acceptance case five. Deployment on standalone mode with Wildfly 9' do

  context 'Initial install Wildfly 9, deployment and verification' do
    it 'Should apply the manifest without error' do

      pp = <<-EOS

          $java_home = $::osfamily ? {
            'RedHat' => '/etc/alternatives/java_sdk',
            'Debian' => "/usr/lib/jvm/java-7-openjdk-${::architecture}",
            default  => undef
          }

          class { 'java': } ->

          class { 'wildfly':
            version        => '9.0.0',
            install_source => 'http://download.jboss.org/wildfly/9.0.0.Final/wildfly-9.0.0.Final.tar.gz',
            java_home      => $java_home,
          } ->

          wildfly::deployment { 'sample.war':
            source => 'https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war'
          }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      shell('sleep 15')
    end

    it 'service wildfly' do
      expect(service 'wildfly').to be_enabled
      expect(service 'wildfly').to be_running
    end

    it 'runs on port 8080' do
      expect(port 8080).to be_listening
    end

    it 'welcome page' do
      shell('curl localhost:8080', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'Welcome'
      end
    end

    it 'downloaded WAR file' do
      shell('ls -al /tmp/sample.war', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '/tmp/sample.war'
      end
    end

    $contextRoot = ""
    it 'deployed application' do
      contextRoot = ''
      shell('/opt/wildfly/bin/jboss-cli.sh --connect "/deployment=sample.war:read-resource(recursive=true)"',
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"outcome" => "success"'
        result = r.stdout.chomp.gsub('=>', ':').gsub(/\[(.*)\]/im, '""').gsub(/\s\d*L/im, ' ""').gsub(/undefined/, ' "undefined"').gsub(/true/, ' "true"')
        parsed = JSON.parse(result)
        contextRoot = parsed["result"]["subsystem"]["undertow"]["context-root"]
      end
      shell('curl localhost:8080'.concat(contextRoot).concat('/hello'), :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'Hello, World'
      end
    end

  end

end