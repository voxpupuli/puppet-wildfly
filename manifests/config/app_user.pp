#
# Add wildfly app user
#
define wildfly::config::app_user($username, $password) {

  wildfly::config::user { $name:
    username  => $username,
    password  => $password,
    file_name => 'application-users.properties',
    realm     => 'ApplicationRealm'
  }

}