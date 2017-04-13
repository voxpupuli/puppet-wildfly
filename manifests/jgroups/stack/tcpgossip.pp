#
# Configures a tcpgossip stack.
#
define wildfly::jgroups::stack::tcpgossip(
  String $initial_hosts,
  Integer $num_initial_members,
  Integer $timeout = 3000,
  ) {

  $properties = {
    'properties' =>  {
      'initial_hosts'       => $initial_hosts,
      'timeout'             => $timeout,
      'num_initial_members' => $num_initial_members,
    }
  }

  wildfly::jgroups::stack::tcp { 'TCPGOSSIP':
    properties => $properties
  }

}
