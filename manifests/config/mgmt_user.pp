#
# Add wildfly management user
#
define wildfly::config::mgmt_user($password) {

  wildfly::config::user { "mgmt_${name}":
    username  => $name,
    password  => $password,
    file_name => 'mgmt-users.properties',
    realm     => 'ManagementRealm',
  }

}
