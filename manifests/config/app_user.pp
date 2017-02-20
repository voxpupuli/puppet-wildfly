#
# Add wildfly app user
#
define wildfly::config::app_user(String $password) {

  wildfly::config::user { "${title}:ApplicationRealm":
    password  => $password,
    file_name => 'application-users.properties',
  }

}
