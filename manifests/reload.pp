define wildfly::reload(
  $retries = 3,
  $wait = 10) {

  require wildfly::service

  wildfly_reload { $name:
    username => $wildfly::mgmt_user['username'],
    password => $wildfly::mgmt_user['password'],
    host     => $wildfly::setup::properties['jboss.bind.address.management'],
    port     => $wildfly::setup::properties['jboss.management.http.port'],
    retries  => $retries,
    wait     => $wait,
  }

}
