#
# Configures a tcpping stack.
#
define wildfly::jgroups::stack::tcpping(
  String $initial_hosts,
  Integer $num_initial_members,
  Integer $timeout = 3000,
  Integer $port_range = 0,
  ) {

  $properties = {
    'properties' =>  {
      'initial_hosts'       => $initial_hosts,
      'timeout'             => $timeout,
      'num_initial_members' => $num_initial_members,
      'port_range'          => $port_range,
    }
  }

  wildfly::jgroups::stack::tcp { 'TCPPING':
    properties => $properties
  }

}
