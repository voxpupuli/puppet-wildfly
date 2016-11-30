#
# Wildfly setup class
#
class wildfly::setup {

  wildfly::config::mgmt_user { $wildfly::mgmt_user['username']:
    password => $wildfly::mgmt_user['password'],
  }

  $properties = merge($wildfly::params::properties, $wildfly::properties)

  file { "${wildfly::dirname}/jboss.properties":
    ensure  => file,
    owner   => $wildfly::user,
    group   => $wildfly::group,
    content => template('wildfly/jboss.properties.erb'),
    notify  => Class['wildfly::service']
  }

  file { "${wildfly::dirname}/bin/${wildfly::mode}.conf":
    ensure  => file,
    owner   => $wildfly::user,
    group   => $wildfly::group,
    content => template($wildfly::mode_template),
    notify  => Class['wildfly::service']
  }

  if $wildfly::secret_value {

    augeas { 'host_config-secret':
      lens    => 'Xml.lns',
      incl    => "${wildfly::dirname}/${wildfly::mode}/configuration/${wildfly::host_config}",
      changes => "set host/management/security-realms/security-realm[#attribute/name='ManagementRealm']/server-identities/secret/#attribute/value ${wildfly::secret_value}",
      onlyif  => "match host/management/security-realms/security-realm[#attribute/name='ManagementRealm']/server-identities/secret[#attribute/value='${wildfly::secret_value}'] size == 0"
    }

  }

}
