#
# Executes a JBoss-CLI command
#
define wildfly::util::exec_cli($command = undef, $unless = undef, $onlyif = undef) {

  wildfly_cli { $name:
    username => keys($::wildfly::users_mgmt)[0],
    password => $::wildfly::users_mgmt['wildfly']['password'],
    host     => $::wildfly::mgmt_bind,
    port     => $::wildfly::mgmt_http_port,
    command  => $command,
    unless   => $unless,
    onlyif   => $onlyif
  }

}
