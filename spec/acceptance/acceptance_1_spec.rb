require 'spec_helper_acceptance'

describe 'Acceptance case one' do

  context 'Initial install Wildfly and verification' do
    it 'Should apply the manifest without error' do
      pp = <<-EOS
        $java_home = $::osfamily ? {
          'RedHat' => '/etc/alternatives/java_sdk',
          'Debian' => "/usr/lib/jvm/java-7-openjdk-${::architecture}",
          default  => undef
        }

        class { 'wildfly':
          java_home => $java_home,
          config    => 'standalone-full-ha.xml',
        }

        class { 'java': }

        Class['java'] ->
          Class['wildfly']
      EOS
      apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0,2])
      shell('sleep 15')
    end
    it 'Should be serving welcome page on port 8080' do
      shell('curl localhost:8080', :acceptable_exit_codes => 0) do |r|
        r.stdout.should match(/Welcome/)
      end
    end
  end

end