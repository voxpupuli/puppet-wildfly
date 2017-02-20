#
# Add wildfly management user
#
define wildfly::config::mgmt_user(String $password) {

  wildfly::config::user { "${title}:ManagementRealm":
    password  => $password,
    file_name => 'mgmt-users.properties',
  }

}
