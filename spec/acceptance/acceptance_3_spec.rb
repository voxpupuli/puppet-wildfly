require 'spec_helper_acceptance'

describe 'Acceptance case three. Standalone mode with Wildfly 9' do
  context 'Initial install Wildfly 9 and verification' do
    it 'Should apply the manifest without error' do
      # update augeas on debian
      # echo 'deb     http://pkg.camptocamp.net/apt wheezy/stable sysadmin' | sudo tee -a /etc/apt/sources.list
      # curl -s http://pkg.camptocamp.net/packages-c2c-key.gpg | sudo apt-key add -
      # apt-get update
      # sudo apt-get install augeas-tools=1.\* augeas-lenses=1.\* augeas-doc=1.\* libaugeas0=1.\*
      # dpkg -l '*augeas*'

      pp = <<-EOS
          case $::osfamily {
            'RedHat': {
              java::oracle { 'jdk8' :
                ensure  => 'present',
                version => '8',
                java_se => 'jdk',
                before  => Class['wildfly']
              }


              $java_home = '/usr/java/default'
             }
            'Debian': {
              class { 'java':
                before => Class['wildfly']
              }

              $java_home = "/usr/lib/jvm/java-7-openjdk-${::architecture}"
           }
          }

          class { 'wildfly':
            java_home      => $java_home,
          }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      shell('sleep 15')
    end

    it 'service wildfly' do
      expect(service('wildfly')).to be_enabled
      expect(service('wildfly')).to be_running
    end

    it 'runs on port 8080' do
      expect(port(8080)).to be_listening
    end

    it 'welcome page' do
      shell('curl localhost:8080', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'Welcome'
      end
    end
  end
end
