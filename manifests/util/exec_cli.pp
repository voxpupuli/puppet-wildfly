#
# Executes a JBoss-CLI command
#
define wildfly::util::exec_cli($action_command = undef, $verify_command = undef) {

  wildfly_cli { $name:
    username => $::wildfly::users_mgmt['wildfly']['username'],
    password => $::wildfly::users_mgmt['wildfly']['password'],
    command  => $action_command,
    unless   => $verify_command,
  }

}