#
# Wildfly setup class
#
class wildfly::setup {

  create_resources(wildfly::config::mgmt_user, $wildfly::users_mgmt)

  file { "${wildfly::dirname}/bin/${wildfly::mode}.conf":
    ensure  => file,
    owner   => $wildfly::user,
    group   => $wildfly::group,
    content => template($wildfly::mode_template),
    notify  => Class['wildfly::service']
  }

  if !empty($wildfly::domain_slave) {

    wildfly::domain::slave { $wildfly::domain_slave['host_name']:
      secret                => $wildfly::domain_slave['secret'],
      domain_master_address => $wildfly::domain_slave['domain_master_address'],
    }

  }

}
