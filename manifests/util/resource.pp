#
# Uses wildfly_resource to ensure configuration state
#
define wildfly::util::resource($ensure = 'present', $content = undef, $recursive = false, $profile = undef) {

  $profile_path = profile_path($profile)

  wildfly_resource { "${profile_path}${name}":
    ensure    => $ensure,
    username  => $::wildfly::users_mgmt['wildfly']['username'],
    password  => $::wildfly::users_mgmt['wildfly']['password'],
    host      => $::wildfly::mgmt_bind,
    port      => $::wildfly::mgmt_http_port,
    recursive => $recursive,
    state     => $content,
  }

}
