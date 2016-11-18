define wildfly::reload(
  $retries = 3,
  $wait = 10) {

  wildfly_reload { $name:
    username => $wildfly::mgmt_user['username'],
    password => $wildfly::mgmt_user['password'],
    host     => $wildfly::properties['jboss.bind.address.management'],
    port     => $wildfly::properties['jboss.management.http.port'],
    retries  => $retries,
    wait     => $wait,
  }

}
