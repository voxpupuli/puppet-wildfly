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

  wildfly_resource { "${profile_path}${name}":
    ensure            => $ensure,
    username          => $wildfly::mgmt_user['username'],
    password          => $wildfly::mgmt_user['password'],
    host              => $wildfly::properties['jboss.bind.address.management'],
    port              => $wildfly::properties['jboss.management.http.port'],
    recursive         => $recursive,
    state             => delete_undef_values($content),
    operation_headers => $operation_headers,
  }

}
