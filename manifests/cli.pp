#
# Executes a JBoss-CLI command
#
define wildfly::cli(
  $command = $name,
  $unless = undef,
  $onlyif = undef) {

  require wildfly::service

  wildfly_cli { $name:
    username => $wildfly::mgmt_user['username'],
    password => $wildfly::mgmt_user['password'],
    host     => $wildfly::setup::properties['jboss.bind.address.management'],
    port     => $wildfly::setup::properties['jboss.management.http.port'],
    command  => $command,
    unless   => $unless,
    onlyif   => $onlyif
  }

}
