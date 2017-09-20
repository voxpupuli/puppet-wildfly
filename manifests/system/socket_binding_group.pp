#
# Configures Socket Binding Groups
#   Uses $title as the Socket Binding Group name. You may have only one group at a time. Jboss default name is 'standard-sockets'
# @param default_interface Name of an interface that should be used as the interface for any sockets that do not explicitly declare one. Defaults are 'management', 'public', 'unsecure'.
# @param port_offset Increment to apply to the base port values defined in the socket bindings to derive the runtime values to use on this server.
# @param socket-bindings Hash of hashes with your socket bindings in the form { 'socket_name' => { 'port' => 8080, ... } }

define wildfly::system::socket_binding_group (
  $default_interface                          = undef,
  $port_offset                                = undef,
  Hash $socket_bindings                       = undef,
){

  wildfly::resource { "/socket-binding-group=${title}":
    content => {
      'default-interface' => $default_interface,
      'port-offset'       => { 'EXPRESSION_VALUE' => $port_offset }
    },
  }
  $socket_bindings.each | $socket, $hash | {
    if $hash['multicast-port'] and !$hash['multicast-port'].is_a(Integer) {
      fail('multicast-port must be of type Integer')
    }
    if $hash['port'] and (!$hash['port'].is_a(Integer) or !$hash['port'].is_a(Hash)) {
      fail('port must be of type Integer or Hash')
    }
    wildfly::resource { "/socket-binding-group=${title}/socket-binding=${socket}":
      content => {
        'client-mappings'   => $hash['client-mappings'],
        'fixed-port'        => $hash['fixed-port'],
        'interface'         => $hash['interface'],
        'multicast-address' => $hash['multicast-address'],
        'multicast-port'    => $hash['multicast-port'],
        'port'              => $hash['port']
      }
    }
  }
}
