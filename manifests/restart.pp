define wildfly::restart(
  $retries = 3,
  $wait = 20) {

  wildfly_restart { $title:
    username => $wildfly::mgmt_user['username'],
    password => $wildfly::mgmt_user['password'],
    host     => $wildfly::setup::properties['jboss.bind.address.management'],
    port     => $wildfly::setup::properties['jboss.management.http.port'],
    retries  => $retries,
    wait     => $wait,
    require  => Service['wildfly'],
  }

}
