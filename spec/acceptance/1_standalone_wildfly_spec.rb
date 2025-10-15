require 'spec_helper_acceptance'

pp = <<-EOP
  Exec {
    path => $facts['path'],
  }
  
  $_properties =  {
    'jboss.bind.address'            => 'localhost',
    'jboss.management.http.port'    => '1081',
    'jboss.management.https.port'   => '10444',
    'jboss.http.port'               => '1080',
    'jboss.https.port'              => '10443',
    'jboss.ajp.port'                => '1234'
    }
  $_service_name = 'very-buggy-server'
  $_uid = '1000'
  $_user = 'wildfly'
  $link_name = '/home/wildfly/'
  
  if $facts['os']['family'] == 'Debian' {
    $javapkg = 'openjdk-17-jdk'
    $javahome = '/usr/lib/jvm/java-17-openjdk-amd64/'
  } else {
    $javapkg = 'java-17-openjdk.x86_64'
    $javahome = '/usr/lib/jvm/java-17-openjdk-17.0.16.0.8-2.el9.x86_64/'
  }

  package { $javapkg:
    ensure => present,
  }
  ->
  group { $_user:
    ensure => present,
    gid => Integer($_uid),
  }
  ->
  user { $_user:
    uid => $_uid,
    gid => $_uid,
  }
  #~>
  #exec {'chown -R wildfly: /opt/wildfly-32.0.1/':
  #  returns => [0,1],
  #}
  ->
  class{'wildfly': 
        config                 => 'standalone.xml',
        console_log            => "/var/log/wildfly/console.log",
        dirname                => "/opt/wildfly-32.0.1", 
        distribution           => "wildfly",
        gid                    => Integer($_uid), 
        group                  => $_user, 
        install_cache_dir      => '/tmp/wildfly/',
        install_source         => '#{test_data['install_source']}',
        java_home              => '#{test_data['java_home']}',
        java_opts              => undef, 
        java_maxmetaspace_size => '2048m',
        java_xms               => '128M',
        java_xmx               => '512M', 
        manage_user            => false, 
        properties             => $_properties, 
        service_name           => '#{test_data['service_name']}', 
        service_manage         => true,
        uid                    => Integer($_uid),
        user                   => $_user, 
        user_home              => $link_name, 
        version                => '32.0.1',
  }    
EOP

describe 'install wildfly and its dependencies and start service' do
  context 'it deduces environment form test_data.rb' do
    it 'applies the manfest without error, idempotently' do
      apply_manifest(pp, catch_failures: true, acceptable_exit_codes: [0, 2])
      apply_manifest(pp, catch_changes: true, acceptable_exit_codes: [0])
    end
  end
end
