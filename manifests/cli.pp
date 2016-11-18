#
# Executes a JBoss-CLI command
#
define wildfly::cli(
  $command = $name,
  $unless = undef,
  $onlyif = undef) {

  wildfly_cli { $name:
    username => $wildfly::mgmt_user['username'],
    password => $wildfly::mgmt_user['password'],
    host     => $::wildfly::mgmt_bind,
    port     => $::wildfly::mgmt_http_port,
    command  => $command,
    unless   => $unless,
    onlyif   => $onlyif
  }

}
