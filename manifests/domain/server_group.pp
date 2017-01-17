define wildfly::domain::server_group($config) {

  wildfly::resource { "/server-group=${title}":
    content => $config,
  }
}
