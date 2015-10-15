#
# Add wildfly management user
#
define wildfly::config::mgmt_user($username, $password) {

  wildfly::config::user { $name:
    username  => $username,
    password  => $password,
    file_name => 'mgmt-users.properties',
    realm     => 'ManagementRealm'
  }

}