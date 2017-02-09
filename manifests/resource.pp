#
# Uses wildfly_resource to ensure configuration state
#
define wildfly::resource(
  $ensure = 'present',
  $recursive = false,
  $content = {},
  $operation_headers = {},
  $profile = undef) {

  $profile_path = profile_path($profile)

  wildfly_resource { "${profile_path}${title}":
    ensure            => $ensure,
    path              => "${profile_path}${title}",
    username          => $wildfly::mgmt_user['username'],
    password          => $wildfly::mgmt_user['password'],
    host              => $wildfly::setup::properties['jboss.bind.address.management'],
    port              => $wildfly::setup::properties['jboss.management.http.port'],
    recursive         => $recursive,
    state             => delete_undef_values($content),
    operation_headers => $operation_headers,
    require           => Service['wildfly'],
  }

}
