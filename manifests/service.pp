#
# Wildfly startup service class
#
class wildfly::service (
	$custom_wildfly_conf_file = undef, # can be set by hiera to override the default conf file location
	$service_name = "wildfly"
){

  $java_home = $wildfly::java_home
  $dirname = $wildfly::dirname
  $user= $wildfly::user
  $mode= $wildfly::mode
  $config= $wildfly::config
  $console_log=$wildfly::console_log

  if $custom_wildfly_conf_file != undef {
	$wildfly_conf_file = $custom_wildfly_conf_file
  }
  else {
    case $::osfamily {
      'RedHat': {
        $wildfly_conf_file = "/etc/default/${service_name}.conf"
      }
      'Debian': {
        $wildfly_conf_file = "/etc/default/${service_name}"
      }
      default: {
        $wildfly_conf_file = "/etc/default/${service_name}.conf"
      }
    }
  }

  file { $wildfly_conf_file:
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('wildfly/wildfly.conf.erb'),
  }

  file { "/etc/init.d/${service_name}":
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => "${wildfly::dirname}/bin/init.d/${wildfly::service_file}",
  }

  service { $service_name:
    ensure     => true,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [File["/etc/init.d/${service_name}"],File[$wildfly_conf_file]]
  }

}