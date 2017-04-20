# Wildfly systemd configuration
#
class wildfly::service::systemd {

  if $wildfly::service::systemd_template == 'wildfly/wildfly.systemd.service' {
    # Use native script
    file { "${wildfly::dirname}/bin/launch.sh" :
      ensure  => present,
      mode    => '0755',
      owner   => $wildfly::user,
      group   => $wildfly::group,
      # need to manage this until it's fixed in the upstream
      content => file('wildfly/launch.sh'),
      before  => File["/etc/systemd/system/${wildfly::service::service_name}.service"],
    }
  } else {
    # Use init.d scripts for systemd
    contain wildfly::service::sysvinit
  }

  file { "/etc/systemd/system/${wildfly::service::service_name}.service":
    ensure  => present,
    mode    => '0755',
    content => epp($wildfly::service::systemd_template),
    before  => Service['wildfly'],
  }

}
