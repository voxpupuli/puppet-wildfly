#
# Wildfly setup class
#
class wildfly::setup {

  create_resources(wildfly::config::mgmt_user, $wildfly::users_mgmt)

  file { "${wildfly::dirname}/bin/${wildfly::mode}.conf":
    ensure  => file,
    owner   => $wildfly::user,
    group   => $wildfly::group,
    content => template('wildfly/standalone.conf.erb'),
    notify  => Class['wildfly::service']
  }

}
