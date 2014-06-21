#
#
class wildfly::install(  
   $version         = '8.1.0',
   $install_source  = undef,
   $install_file    = undef,
   $java_home       = undef,
   $group           = $wildfly::params::wildfly_group,
   $user            = $wildfly::params::wildfly_user,
   $dirname         = $wildfly::params::wildfly_dirname,
   $service_file    = $wildfly::params::wildfly_service_file,
   $mode            = $wildfly::params::wildfly_mode,
   $config          = $wildfly::params::wildfly_config,
) inherits wildfly::params  {

  group { $group :
    ensure => present,
  }

  # http://raftaman.net/?p=1311 for generating password
  # password = wildfly
  user { $user :
    ensure     => present,
    groups     => $group,
    shell      => '/bin/bash',
    password   => '$1$d0AuSVPS$WhuUjhtX3ejUHxQQImEkk/',
    home       => "/home/${user}",
    comment    => "$user} user created by Puppet",
    managehome => true,
    require    => Group[$group],
  }

  file{$dirname :
    ensure     => directory,
    owner      => $user,
    group      => $group,
    mode       => '0755',
    require    => User[$user],
  }

  if !defined(Package['libaio']) {
    package { 'libaio':
      ensure  => present,
    }
  }
  if !defined(Package['wget']) {
    package { 'wget':
      ensure  => present,
      before  => Exec["Retrieve ${install_source} in /var/tmp"],  
    }
  }

  exec { "Retrieve ${install_source} in /var/tmp":
    cwd         => '/var/tmp',
    command     => "wget  -c --no-cookies --no-check-certificate \"${install_source}\" -O ${install_file}",
    creates     => "/var/tmp/${install_file}",
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  exec { "tar ${install_file} in /var/tmp":
    cwd         => '/var/tmp',
    command     => "tar xzf ${install_file} -C ${dirname} --strip 1",
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    require     => [Exec["Retrieve ${install_source} in /var/tmp"],
                    File[$dirname],],
    creates     => "${dirname}/jboss-modules.jar",                
    user        => $user,
    group       => $group,
  }

  file{'/etc/init.d/wildfly':
    ensure     => present,
    mode       => '0755',
    owner      => 'root',
    group      => 'root',
    content    => template("wildfly/${service_file}"),
  }


  file{'/etc/default/wildfly.conf':
    ensure     => present,
    mode       => '0755',
    owner      => 'root',
    group      => 'root',
    content    => template("wildfly/wildfly.conf.erb"),
  }


}