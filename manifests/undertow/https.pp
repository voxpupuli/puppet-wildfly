#
# Configures a connector
#
define wildfly::undertow::https($socket_binding = undef, $keystore_path = undef, $keystore_password = undef, $key_alias = undef, $key_password = undef, $target_profile = undef) {

  if versioncmp($wildfly::version,'9.0.0') >= 0 {
    # Wildfly 9 and higher -> we need to set enable parameter
    $listener_content = {
      'socket-binding' => $socket_binding,
      'security-realm' => 'TLSRealm',
      'enable'         => true,
    }
  } else {
    $listener_content = {
      'socket-binding' => $socket_binding,
      'security-realm' => 'TLSRealm',
    }
  }

  wildfly::util::resource { '/core-service=management/security-realm=TLSRealm':
    content => {},
  }
  ->
  wildfly::util::resource { '/core-service=management/security-realm=TLSRealm/server-identity=ssl':
    content => {
      'keystore-path'     => $keystore_path,
      'keystore-password' => $keystore_password,
      'alias'             => $key_alias,
      'key-password'      => $key_password
    },
  }
  ->
  wildfly::util::resource { "/subsystem=undertow/server=default-server/https-listener=${name}":
    content => $listener_content,
    profile => $target_profile,
  }

}
