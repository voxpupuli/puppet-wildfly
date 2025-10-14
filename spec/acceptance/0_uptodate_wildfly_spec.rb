require 'spec_helper_acceptance'

pp = <<-EOP
  Exec {
    path => $facts['path'],
  }
  
  # yum install java-17-openjdk.x86_64
  
  $_install_source = 'https://github.com/wildfly/wildfly/releases/download/37.0.1.Final/wildfly-37.0.1.Final.tar.gz'
  $_install_source_gitlab_issue_355 = 'https://github.com/wildfly/wildfly/releases/download/32.0.1.Final/wildfly-32.0.1.Final.tar.gz'
  $_properties =  {
    'jboss.bind.address'            => 'localhost',
  #    'jboss.bind.address.management' => $mgmt_bind,
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
  
  package {'java-17-openjdk.x86_64':
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
        install_source         => $_install_source_gitlab_issue_355, 
        java_home              => '/usr/lib/jvm/jre-17-openjdk',
        java_opts              => undef, 
        java_maxmetaspace_size => '2048m',
        java_xms               => '128M',
        java_xmx               => '512M', 
        manage_user            => false, 
        properties             => $_properties, 
        service_name           => $_service_name, 
        service_manage         => true,
        uid                    => Integer($_uid),
        user                   => $_user, 
        user_home              => $link_name, 
        version                => '32.0.1',
  }    
EOP

describe 'up to date wildfly without any frills' do
  context 'it installs at least once' do
    it 'applies the manfest without error, idempotently' do
      apply_manifest(pp, catch_failures: true, acceptable_exit_codes: [0, 2])
      apply_manifest(pp, catch_failures: true, catch_changes: true, acceptable_exit_codes: [0])
    end
  end
end
