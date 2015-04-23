define wildfly::standalone::deploy($ensure = present, $source = undef) {

  wildfly_deploy { $name:
    ensure => $ensure,
    username => $::wildfly::users_mgmt['wildfly']['username'],
    password => $::wildfly::users_mgmt['wildfly']['password'],
    source   => $source
  }

}