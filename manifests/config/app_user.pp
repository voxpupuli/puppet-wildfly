#
# Add wildfly app user
#
define wildfly::config::app_user($password) {

  wildfly::config::user { "${title}:ApplicationRealm":
    password  => $password,
    file_name => 'application-users.properties',
  }

}
