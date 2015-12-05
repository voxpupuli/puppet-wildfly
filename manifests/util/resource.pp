#
# Uses wildfly_resource to ensure configuration state
#
define wildfly::util::resource($ensure = 'present', $content = undef, $recursive = false, $profile = undef) {

  $profile_path = profile_path($profile)

  wildfly_resource { "${profile_path}${name}":
    ensure    => $ensure,
    username  => keys($::wildfly::users_mgmt)[0],
    password  => $::wildfly::users_mgmt['wildfly']['password'],
    host      => $::wildfly::mgmt_bind,
    port      => $::wildfly::mgmt_http_port,
    recursive => $recursive,
    state     => delete_undef_values($content),
  }

}
