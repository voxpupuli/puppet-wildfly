define wildfly::domain::server_group($config) {

  wildfly::resource { "/server-group=${name}":
    content => $config,
  }
}
