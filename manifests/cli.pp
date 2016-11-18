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
    host     => $wildfly::properties['jboss.bind.address.management'],
    port     => $wildfly::properties['jboss.management.http.port'],
    command  => $command,
    unless   => $unless,
    onlyif   => $onlyif
  }

}
