define wildfly::host::server_config($config) {

  wildfly::resource { "/host=${::hostname}/server-config=${name}":
    content => $config,
  }
}
