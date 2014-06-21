#
#
class wildfly::install() inherits wildfly {

  group { $wildfly::wildfly_group :
    ensure => present,
  }

  # http://raftaman.net/?p=1311 for generating password
  # password = wildfly
  user { $wildfly::wildfly_user :
    ensure     => present,
    groups     => $wildfly::wildfly_group,
    shell      => '/bin/bash',
    password   => '$1$d0AuSVPS$WhuUjhtX3ejUHxQQImEkk/',
    home       => "/home/${wildfly::wildfly_user}",
    comment    => "${wildfly::wildfly_user} user created by Puppet",
    managehome => true,
    require    => Group[$wildfly::wildfly_group],
  }

  file{$wildfly::wildfly_dirname :
    ensure     => directory,
    owner      => $wildfly::wildfly_user,
    group      => $wildfly::wildfly_group,
    mode       => '0755',
    require    => User[$wildfly::wildfly_user],
  }

  if !defined(Package['libaio']) {
    package { 'libaio':
      ensure  => present,
    }
  }
  if !defined(Package['wget']) {
    package { 'wget':
      ensure  => present,
      before  => Exec["Retrieve ${wildfly::source} in /var/tmp"],  
    }
  }

  exec { "Retrieve ${wildfly::source} in /var/tmp":
    cwd         => '/var/tmp',
    command     => "wget  -c --no-cookies --no-check-certificate \"${wildfly::install_source}\" -O ${wildfly::install_file}",
    creates     => "/var/tmp/${wildfly::install_file}",
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  exec { "tar ${wildfly::install_file} in /var/tmp":
    cwd         => '/var/tmp',
    command     => "tar xzf ${wildfly::install_file} -C ${wildfly::wildfly_dirname} --strip 1",
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    require     => [Exec["Retrieve ${wildfly::source} in /var/tmp"],
                    File[$wildfly::wildfly_dirname],],
    creates     => "${wildfly::wildfly_dirname}/jboss-modules.jar",                
    user        => $wildfly::wildfly_user,
    group       => $wildfly::wildfly_group,
  }

  file{'/etc/init.d/wildfly-init.sh':
    ensure     => present,
    mode       => '0755',
    owner      => 'root',
    group      => 'root',
    content    => template("wildfly/${wildfly::wildfly_service_file}"),
  }

  $java_home       = $wildfly::java_home
  $wildfly_group   = $wildfly::wildfly_group
  $wildfly_user    = $wildfly::wildfly_user
  $wildfly_dirname = $wildfly::wildfly_dirname
  $wildfly_mode    = $wildfly::wildfly_mode
  $wildfly_config  = $wildfly::wildfly_config

  file{'/etc/default/wildfly.conf':
    ensure     => present,
    mode       => '0755',
    owner      => 'root',
    group      => 'root',
    content    => template("wildfly/wildfly.conf.erb"),
  }


}