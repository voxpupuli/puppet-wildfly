require 'spec_helper_acceptance'

describe 'Acceptance case one. Standalone mode with defaults' do

  context 'Initial install Wildfly and verification' do
    it 'Should apply the manifest without error' do

      # update augeas on debian
      # echo 'deb     http://pkg.camptocamp.net/apt wheezy/stable sysadmin' | sudo tee -a /etc/apt/sources.list
      # curl -s http://pkg.camptocamp.net/packages-c2c-key.gpg | sudo apt-key add -
      # apt-get update
      # sudo apt-get install augeas-tools=1.\* augeas-lenses=1.\* augeas-doc=1.\* libaugeas0=1.\*
      # dpkg -l '*augeas*'

      pp = <<-EOS

          $java_home = $::osfamily ? {
            'RedHat' => '/etc/alternatives/java_sdk',
            'Debian' => "/usr/lib/jvm/java-7-openjdk-${::architecture}",
            default  => undef
          }

          class { 'wildfly':
            java_home => $java_home,
          }

          wildfly::config::module { 'org.postgresql':
            source       => 'http://central.maven.org/maven2/org/postgresql/postgresql/9.3-1103-jdbc4/postgresql-9.3-1103-jdbc4.jar',
            dependencies => ['javax.api', 'javax.transaction.api']
          }

          wildfly::config::module { 'empty.module':
            source       => '.'
          }

          class { 'java': }

          Class['java'] -> Class['wildfly']
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

    it 'contains postgresql module' do
      shell('ls -la /opt/wildfly/modules/system/layers/base/org/postgresql/main', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'postgresql-9.3-1103-jdbc4.jar'
        expect(r.stdout).to include 'module.xml'
      end
    end

    it 'contains empty module' do
      shell('ls -la /opt/wildfly/modules/system/layers/base/empty/module/main', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'module.xml'
      end
      shell('cat /opt/wildfly/modules/system/layers/base/empty/module/main/module.xml', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '<resource-root path="."/>'
      end
    end

  end

end
