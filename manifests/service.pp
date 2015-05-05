#
# Wildfly startup service class
#
class wildfly::service {

  case $::osfamily {
    'RedHat': {
      $wildfly_conf_file = '/etc/default/wildfly.conf'
    }
    'Debian': {
      $wildfly_conf_file = '/etc/default/wildfly'
    }
    default: {
      $wildfly_conf_file = '/etc/default/wildfly.conf'
    }
  }

  file { $wildfly_conf_file:
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('wildfly/wildfly.conf.erb'),
  }

  file { '/etc/init.d/wildfly':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => "${wildfly::dirname}/bin/init.d/${wildfly::service_file}",
  }

  service { 'wildfly':
    ensure     => true,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [File['/etc/init.d/wildfly'],File[$wildfly_conf_file]]
  }

}
