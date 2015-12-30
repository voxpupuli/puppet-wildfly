#
# Wildfly startup service class
#
class wildfly::service {

  file { $::wildfly::conf_file:
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('wildfly/wildfly.conf.erb'),
    notify  => Service[$::wildfly::service_name]
  }

  if $::wildfly::custom_init {
    # Pass custom initd script template for starting wildfly
    file { "/etc/init.d/${::wildfly::service_name}":
      ensure  => present,
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      content => template($::wildfly::custom_init),
    }
  } else {
    # Use/Copy default initd script from installation
    file { "/etc/init.d/${::wildfly::service_name}":
      ensure => present,
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
      source => "${::wildfly::dirname}/bin/init.d/${::wildfly::service_file}",
    }
  }

  if ( $::operatingsystem in ['CentOS', 'RedHat', 'OracleLinux'] and $::operatingsystemmajrelease == '7') {
    # enabled is not yet implemented
    service { $::wildfly::service_name:
      ensure     => $::wildfly::service_ensure,
      hasrestart => true,
      hasstatus  => true,
      require    => [File["/etc/init.d/${::wildfly::service_name}"], File[$::wildfly::conf_file]]
    }
  } else {
    service { $::wildfly::service_name:
      ensure     => $::wildfly::service_ensure,
      enable     => $::wildfly::service_enable,
      hasrestart => true,
      hasstatus  => true,
      require    => [File["/etc/init.d/${::wildfly::service_name}"], File[$::wildfly::conf_file]]
    }
  }
}
