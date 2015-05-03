#
# Wildlfy prepare class
#
class wildfly::prepare {

  ## extract user prepare
  group { $wildfly::group :
    ensure => present,
  }

  user { $wildfly::user :
    ensure     => present,
    groups     => $wildfly::group,
    shell      => '/bin/bash',
    home       => "/home/${wildfly::user}",
    comment    => "${wildfly::user} user created by Puppet",
    managehome => true,
    require    => Group[$wildfly::group],
  }

  # extract dir
  file { $wildfly::dirname :
    ensure  => directory,
    owner   => $wildfly::user,
    group   => $wildfly::group,
    mode    => '0755',
    require => User[$wildfly::user],
  }

  ## extract dependencies
  $libaiopackage  = $::osfamily ? {
    'RedHat' => 'libaio',
    'Debian' => 'libaio1',
    default  => 'libaio',
  }

  if !defined(Package[$libaiopackage]) {
    package { $libaiopackage:
      ensure => present,
    }
  }

}