define wildfly::web::connector(
  $scheme,
  $protocol,
  $socket_binding,
  $enable_lookups,
  $secure,) {

  $params = {
    'name' => $name,
    'scheme' => $scheme,
    'protocol' => $protocol,
    'socket-binding' => $socket_binding,
    'enable-lookups' => $enable_lookups,
    'secure' => $secure
  }

  wildfly::resource { "/subsystem=web/connector=${name}":
    content => $params
  }

}
