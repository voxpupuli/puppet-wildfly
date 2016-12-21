#
# Manages Wildfly patches offline
#
define wildfly::patch::offline($source, $override_all = false, $override = [], $preserve = []) {

  require wildfly::install

  $args = patch_args($source, $override_all, $override, $preserve)

  exec { "Patch ${name}":
    command     => "jboss-cli.sh 'patch apply ${args}'",
    unless      => "jboss-cli.sh 'patch history' | grep -q ${name}",
    path        => ['/bin', '/usr/bin', '/sbin', "${wildfly::dirname}/bin"],
    environment => "JAVA_HOME=${wildfly::java_home}",
  }
}
