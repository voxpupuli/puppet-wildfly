#
# Executes a JBoss-CLI command
#
define wildfly::util::exec_cli($command = undef, $unless = undef, $onlyif = undef) {

  wildfly_cli { $name:
    username => $::wildfly::users_mgmt['wildfly']['username'],
    password => $::wildfly::users_mgmt['wildfly']['password'],
    host     => $::wildfly::mgmt_bind,
    port     => $::wildfly::mgmt_http_port,
    command  => $command,
    unless   => $unless,
    onlyif   => $onlyif
  }

}