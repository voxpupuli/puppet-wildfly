#
# Add wildfly app user
#
define wildfly::config::add_app_user($username = undef, $password = undef) {

  wildfly::config::add_user { $title:
    username  => $username,
    password  => $password,
    file_name => 'application-users.properties',
    realm     => 'ApplicationRealm'
  }

}