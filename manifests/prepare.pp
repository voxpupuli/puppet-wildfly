#
# Wildlfy prepare class
#
class wildfly::prepare {
  ensure_resource('package', 'curl', {'ensure' => 'present'})
  
  if $wildfly::manage_user {

    group { $wildfly::group :
      ensure => present,
      gid    => $wildfly::gid,
    }

    user { $wildfly::user :
      ensure     => present,
      uid        => $wildfly::uid,
      gid        => $wildfly::gid,
      groups     => $wildfly::group,
      shell      => '/bin/bash',
      home       => "/home/${wildfly::user}",
      comment    => "${wildfly::user} user created by Puppet",
      managehome => true,
      require    => Group[$wildfly::group],
    }
  }

  file { $wildfly::dirname :
    ensure  => directory,
    owner   => $wildfly::user,
    group   => $wildfly::group,
    mode    => '0755',
    require => User[$wildfly::user],
  }

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
