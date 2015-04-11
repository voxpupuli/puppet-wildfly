#
# Executes a JBoss-CLI command
#
define wildfly::util::exec_cli($condition = 'success', $post_exec_command = 'exit', $action_command = undef, $verify_command = undef) {

  exec { "JBoss-CLI: ${title}":
    command => "jboss-cli.sh -c --commands='${action_command},${post_exec_command}'",
    unless  => "jboss-cli.sh -c --command='${verify_command}' | grep '${condition}'",
    path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin', "${wildfly::dirname}/bin"],
    require => Service['wildfly']
  }

}