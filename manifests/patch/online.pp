#
# Manages Wildfly patches online
#
define wildfly::patch::online(
  Stdlib::Unixpath $source,
  Optional[Boolean] $override_all = false,
  Array $override = [],
  Array $preserve = []) {

  $args = patch_args($source, $override_all, $override, $preserve)

  exec { "Patch ${title}":
    command     => "jboss-cli.sh -c 'patch apply ${args}'",
    unless      => "jboss-cli.sh -c 'patch history' | grep -q ${title}",
    path        => ['/bin', '/usr/bin', '/sbin', "${wildfly::dirname}/bin"],
    environment => "JAVA_HOME=${wildfly::java_home}",
    require     => Service['wildfly'],
  }
  ~>
  wildfly::restart { "Restart for patch ${title}":
  }
}
