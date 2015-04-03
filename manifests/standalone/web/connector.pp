#
# Configures a connector
#
define wildfly::standalone::web::connector($name = undef, $scheme = undef, $protocol = undef, $socket_binding = undef, $enable_lookups = undef, $secure = undef) {

  $params = {
    'name' => $name,
    'scheme' => $scheme,
    'protocol' => $protocol,
    'socket-binding' => $socket_binding,
    'enable-lookups' => $enable_lookups,
    'secure' => $secure
  }

  wildfly::util::cli { $title:
    content => $params,
    path    => "/subsystem=web/connector=${name}"
  }

}