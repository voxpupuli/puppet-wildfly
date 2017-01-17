#
# Executes a JBoss-CLI command
#
define wildfly::cli(
  $command = $title,
  $unless = undef,
  $onlyif = undef) {

  wildfly_cli { $title:
    command  => $command,
    username => $wildfly::mgmt_user['username'],
    password => $wildfly::mgmt_user['password'],
    host     => $wildfly::setup::properties['jboss.bind.address.management'],
    port     => $wildfly::setup::properties['jboss.management.http.port'],
    unless   => $unless,
    onlyif   => $onlyif,
    require  => Service['wildfly'],
  }

}
