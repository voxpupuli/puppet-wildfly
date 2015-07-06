#
# Uses wildfly_resource to ensure configuration state
#
define wildfly::util::resource($content = undef, $recursive = false, $ensure = 'present') {

  wildfly_resource { $name:
    username  => $::wildfly::users_mgmt['wildfly']['username'],
    password  => $::wildfly::users_mgmt['wildfly']['password'],
    host      => $::wildfly::mgmt_bind,
    port      => $::wildfly::mgmt_http_port,
    recursive => $recursive,
    state     => $content,
    ensure    => $ensure
  }

}
