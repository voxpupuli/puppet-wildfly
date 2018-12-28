#
# Configures jgroups stacks
#
define wildfly::jgroups::stack(
  Array[Variant[Hash, String]] $protocols,
  Hash $transport,
  ) {

  wildfly::resource { "/subsystem=jgroups/stack=${title}":
    recursive => true,
    content   => {
      'protocol'  => wildfly::objectify($protocols),
      'transport' => $transport,
    }
  }
}
