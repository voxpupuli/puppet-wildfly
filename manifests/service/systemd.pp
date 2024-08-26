# Wildfly systemd configuration
#
class wildfly::service::systemd {
  # Use native script
  file { "${wildfly::dirname}/bin/launch.sh" :
    ensure  => file,
    mode    => '0755',
    owner   => $wildfly::user,
    group   => $wildfly::group,
    # need to manage this until it's fixed in the upstream
    content => file('wildfly/launch.sh'),
    before  => File["/etc/systemd/system/${wildfly::service::service_name}.service"],
  }

  file { "/etc/systemd/system/${wildfly::service::service_name}.service":
    ensure  => file,
    mode    => '0644',
    content => epp($wildfly::service::systemd_template),
    before  => Service['wildfly'],
  }
}
