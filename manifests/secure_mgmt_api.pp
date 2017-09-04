class wildfly::secure_mgmt_api {

#Service needs to be running
require wildfly::service

$mgmt_port = $wildfly::properties['jboss.management.https.port']

  if ($wildfly::mgmt_ssl_cert) and ($wildfly::mgmt_ssl_key) {

    $ks_key = $wildfly::mgmt_ssl_key
    $ks_cert  = $wildfly::mgmt_ssl_cert
  }

  else {

    $ks_key = "${wildfly::dirname}/${wildfly::mode}/configuration/mgmt.key"
    $ks_cert = "${wildfly::dirname}/${wildfly::mode}/configuration/mgmt.crt"

    #Generate self signed cert
    exec { 'generate_mgmt_ssl_cert':
      command => "openssl req -newkey rsa:4096 -nodes -sha256 -keyout ${ks_key} -x509 -days 3650 -out ${ks_cert} -subj '/CN=${::fqdn}'",
      creates => [ "${wildfly::dirname}/${wildfly::mode}/configuration/mgmt.key", "${wildfly::dirname}/${wildfly::mode}/configuration/mgmt.crt" ],
      path    => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
      user    => $wildfly::user,
    }

  }

  java_ks { "mgmt:mgmtks":
    ensure      => latest,
    certificate => $ks_cert,
    private_key => $ks_key,
    target      => "${wildfly::dirname}/${wildfly::mode}/configuration/mgmt.jks",
    password    => 'changeit',
    path        => ["${wildfly::java_home}/bin"],
    notify      => Exec['secure mgmt reload'],
  }

  file { "${wildfly::dirname}/${wildfly::mode}/configuration/mgmt.jks":
    owner   => $wildfly::user,
    group   => $wildfly::group,
    require =>  Java_ks['mgmt:mgmtks'],
  }

  #Reload after changes
  exec { 'secure mgmt reload':
    command     => "jboss-cli.sh -c ':reload'",
    refreshonly => true,
    path        => ['/bin', '/usr/bin', '/sbin', "${wildfly::dirname}/bin", "${wildfly::java_home}/bin"],
  }

  java_ks { 'cli:truststore':
    ensure      => latest,
    certificate => $ks_cert,
    password    => 'cli_truststore',
    target      => '/root/.jboss-cli.truststore',
    path        => ["${wildfly::java_home}/bin"],
    require     => Exec['secure mgmt reload'],
  }

  java_ks { 'wfcli:truststore':
    ensure      => latest,
    certificate => $ks_cert,
    password    => 'cli_truststore',
    target      => "/home/${wildfly::user}/.jboss-cli.truststore",
    path        => ["${wildfly::java_home}/bin"],
    require     => Exec['secure mgmt reload'],
  }

  file { "/home/${wildfly::user}/.jboss-cli.truststore":
    owner   => $wildfly::user,
    group   => $wildfly::group,
    require => Java_ks['wfcli:truststore'],
  }

  exec { 'Set https management interface':
    command     => "jboss-cli.sh -c '/core-service=management/management-interface=http-interface:write-attribute(name=secure-socket-binding, value=management-https)'",
    unless      => "grep -c \'https=\"management-https\"\' ${wildfly::dirname}/${wildfly::mode}/configuration/${wildfly::config}",
    path        => ['/bin', '/usr/bin', '/sbin', "${wildfly::dirname}/bin", "${wildfly::java_home}/bin"],
  }

  # Set Realm to use the keystore
  exec { 'Set Realm to use SSL':
    command     => "jboss-cli.sh -c \'/core-service=management/security-realm=ManagementRealm/server-identity=ssl:add(keystore-path=mgmt.jks,keystore-relative-to=jboss.server.config.dir,keystore-password=changeit,alias=mgmt\'",
    unless      => "grep -c mgmt.jks ${wildfly::dirname}/${wildfly::mode}/configuration/${wildfly::config}",
    path        => ['/bin', '/usr/bin', '/sbin', "${wildfly::dirname}/bin", "${wildfly::java_home}/bin"],
    environment => "JAVA_HOME=${wildfly::java_home}",
    notify      => Exec['secure mgmt reload'],
  }

  # Set changes to jboss-cli.xml
  augeas { 'set_jboss_cli_xml_https':
    lens    => 'Xml.lns',
    incl    => "${wildfly::dirname}/bin/jboss-cli.xml",
    changes => ['set jboss-cli/default-controller/protocol/#text https-remoting',
                "set jboss-cli/default-controller/port/#text ${mgmt_port}" ],
  }

}
