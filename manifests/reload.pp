define wildfly::reload(
  $retries = 3,
  $wait = 10) {

  wildfly_reload { $name:
    username => $wildfly::mgmt_user['username'],
    password => $wildfly::mgmt_user['password'],
    host     => $::wildfly::mgmt_bind,
    port     => $::wildfly::mgmt_http_port,
    retries  => $retries,
    wait     => $wait,
  }

}
