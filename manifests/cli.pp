#
# Executes a JBoss-CLI command
#
define wildfly::cli(
  $command = $name,
  $unless = undef,
  $onlyif = undef) {

  $users_mgmt = keys($::wildfly::users_mgmt)
  $passwords_mgmt = values($::wildfly::users_mgmt)

  wildfly_cli { $name:
    username => $users_mgmt[0],
    password => $passwords_mgmt[0]['password'],
    host     => $::wildfly::mgmt_bind,
    port     => $::wildfly::mgmt_http_port,
    command  => $command,
    unless   => $unless,
    onlyif   => $onlyif
  }

}
