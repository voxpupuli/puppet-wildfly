#
# Uses wildfly_resource to ensure configuration state
#
define wildfly::util::cli($content = undef) {

  wildfly_resource { $name:
    username => $::wildfly::users_mgmt['wildfly']['username'],
    password => $::wildfly::users_mgmt['wildfly']['password'],
    state    => $content
  }

}