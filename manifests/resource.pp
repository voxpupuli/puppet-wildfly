#
# Manages a Wildfly configuration resource: e.g `/subsystem=datasources/data-source=MyDS or /subsystem=datasources/jdbc-driver=postgresql`.
#   Virtually anything in your configuration XML file that can be manipulated using JBoss-CLI could be managed by this defined type.
#   This define is a wrapper for `wildfly_resource` that defaults to your local Wildfly installation.
#
# @param ensure Whether the resource should exist (`present`) or not (`absent`).
# @param recursive Whether it should manage the resource recursively or not.
# @param undefine_attributes Whether it should undefine attributes with undef value.
# @param content Sets the content/state of the target resource.
# @param operation_headers Sets [operation-headers](https://docs.jboss.org/author/display/WFLY9/Admin+Guide#AdminGuide-OperationHeaders) (e.g. `{ 'allow-resource-service-restart' => true, 'rollback-on-runtime-failure' => false, 'blocking-timeout' => 600}`) to be used when creating/destroying this resource.
# @param profile Sets the target profile to prefix resource name. Requires domain mode.
define wildfly::resource(
  Enum[present, absent] $ensure = present,
  Boolean $recursive = false,
  Boolean $undefine_attributes = false,
  Hash $content = {},
  Hash $operation_headers = {},
  Optional[String] $profile = undef) {

  $profile_path = wildfly::profile_path($profile)

  if $undefine_attributes {
    $attributes = $content
  } else {
    $attributes = delete_undef_values($content)
  }
  if $wildfly::secure_mgmt_api {
    $mgmt_port = $wildfly::properties['jboss.management.https.port']
    $mgmt_protocol = 'https'
  }

  else {
    $mgmt_port = $wildfly::properties['jboss.management.http.port']
    $mgmt_protocol = 'http'
  }

  wildfly_resource { "${profile_path}${title}":
    ensure            => $ensure,
    path              => "${profile_path}${title}",
    username          => $wildfly::mgmt_user['username'],
    password          => $wildfly::mgmt_user['password'],
    host              => $wildfly::properties['jboss.bind.address.management'],
    port              => $mgmt_port,
    protocol          => $mgmt_protocol,
    recursive         => $recursive,
    state             => $attributes,
    operation_headers => $operation_headers,
    require           => Service['wildfly'],
  }
}
