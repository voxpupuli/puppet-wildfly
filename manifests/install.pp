#
#
class wildfly::install(
  $version           = '8.1.0',
  $install_source    = undef,
  $install_file      = undef,
  $java_home         = undef,
  $group             = $wildfly::params::group,
  $user              = $wildfly::params::user,
  $dirname           = $wildfly::params::dirname,
  $service_file      = $wildfly::params::service_file,
  $mode              = $wildfly::params::mode,
  $config            = $wildfly::params::config,
  $java_xmx          = $wildfly::params::java_xmx,
  $java_xms          = $wildfly::params::java_xms,
  $java_maxpermsize  = $wildfly::params::java_maxpermsize,
  $mgmt_bind         = $wildfly::params::mgmt_bind,
  $public_bind       = $wildfly::params::public_bind,
  $mgmt_http_port    = $wildfly::params::mgmt_http_port,
  $mgmt_https_port   = $wildfly::params::mgmt_https_port,
  $public_http_port  = $wildfly::params::public_http_port,
  $public_https_port = $wildfly::params::public_https_port,
  $ajp_port          = $wildfly::params::ajp_port,
  $users_mgmt        = $wildfly::params::users_mgmt,
) inherits wildfly::params  {

  group { $group :
    ensure => present,
  }

  # http://raftaman.net/?p=1311 for generating password
  # password = wildfly
  user { $user :
    ensure     => present,
    groups     => $group,
    shell      => '/bin/bash',
    password   => '$1$d0AuSVPS$WhuUjhtX3ejUHxQQImEkk/',
    home       => "/home/${user}",
    comment    => "${user} user created by Puppet",
    managehome => true,
    require    => Group[$group],
  }

  file{$dirname :
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => User[$user],
  }

  $libaiopackage  = $::osfamily ? {
    'RedHat' => 'libaio',
    'Debian' => 'libaio1',
    default  => 'libaio',
  }

  if !defined(Package[$libaiopackage]) {
    package { $libaiopackage:
      ensure => present,
    }
  }
  if !defined(Package['wget']) {
    package { 'wget':
      ensure => present,
      before => Exec["Retrieve ${install_source} in /var/tmp"],
    }
  }

  exec { "Retrieve ${install_source} in /var/tmp":
    cwd     => '/var/tmp',
    command => "wget  -c --no-cookies --no-check-certificate \"${install_source}\" -O ${install_file}",
    creates => "/var/tmp/${install_file}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    timeout => 900,
  }

  exec { "tar ${install_file} in /var/tmp":
    cwd     => '/var/tmp',
    command => "tar xzf ${install_file} -C ${dirname} --strip 1",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    require => [Exec["Retrieve ${install_source} in /var/tmp"],File[$dirname],],
    creates => "${dirname}/jboss-modules.jar",
    user    => $user,
    group   => $group,
  }

  # file /opt/wildfly/bin/standalone.conf
  # default JAVA_OPTS="-Xms64m -Xmx512m -XX:MaxPermSize=256m
  exec { 'replace memory parameters':
    command => "sed -i -e's/\\-Xms64m \\-Xmx512m \\-XX:MaxPermSize=256m/\\-Xms${java_xms} \\-Xmx${java_xmx} \\-XX:MaxPermSize=${java_maxpermsize}/g' ${dirname}/bin/standalone.conf",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    onlyif  => "grep '\\-Xms64m \\-Xmx512m \\-XX:MaxPermSize=256m' ${dirname}/bin/standalone.conf",
    require => Exec["tar ${install_file} in /var/tmp"],
    before  => Service['wildfly'],
  }

  Exec['replace management bind'] ->
    Exec['replace public bind'] ->
      Exec['replace management http port'] ->
        Exec['replace management https port'] ->
          Exec['replace http port'] ->
            Exec['replace https port'] ->
              Exec['replace ajp port']

  exec { 'replace management bind':
    command => "sed -i -e's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:${mgmt_bind}/g' ${dirname}/standalone/configuration/${config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    onlyif  => "grep 'jboss.bind.address.management:127.0.0.1' ${dirname}/standalone/configuration/${config}",
    require => Exec["tar ${install_file} in /var/tmp"],
    before  => Service['wildfly'],
  }

  exec { 'replace public bind':
    command => "sed -i -e's/jboss.bind.address:127.0.0.1/jboss.bind.address:${public_bind}/g' ${dirname}/standalone/configuration/${config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    onlyif  => "grep 'jboss.bind.address:127.0.0.1' ${dirname}/standalone/configuration/${config}",
    require => Exec["tar ${install_file} in /var/tmp"],
    before  => Service['wildfly'],
  }

  exec { 'replace management http port':
    command => "sed -i -e's/jboss.management.http.port:9990/jboss.management.http.port:${mgmt_http_port}/g' ${dirname}/standalone/configuration/${config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    onlyif  => "grep 'jboss.management.http.port:9990' ${dirname}/standalone/configuration/${config}",
    require => Exec["tar ${install_file} in /var/tmp"],
    before  => Service['wildfly'],
  }

  exec { 'replace management https port':
    command => "sed -i -e's/jboss.management.https.port:9993/jboss.management.https.port:${mgmt_https_port}/g' ${dirname}/standalone/configuration/${config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    onlyif  => "grep 'jboss.management.https.port:9993' ${dirname}/standalone/configuration/${config}",
    require => Exec["tar ${install_file} in /var/tmp"],
    before  => Service['wildfly'],
  }

  exec { 'replace http port':
    command => "sed -i -e's/jboss.http.port:8080/jboss.http.port:${public_http_port}/g' ${dirname}/standalone/configuration/${config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    onlyif  => "grep 'jboss.http.port:8080' ${dirname}/standalone/configuration/${config}",
    require => Exec["tar ${install_file} in /var/tmp"],
    before  => Service['wildfly'],
  }

  exec { 'replace https port':
    command => "sed -i -e's/jboss.https.port:8443/jboss.https.port:${public_https_port}/g' ${dirname}/standalone/configuration/${config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    onlyif  => "grep 'jboss.https.port:8443' ${dirname}/standalone/configuration/${config}",
    require => Exec["tar ${install_file} in /var/tmp"],
    before  => Service['wildfly'],
  }

  exec { 'replace ajp port':
    command => "sed -i -e's/jboss.ajp.port:8009/jboss.ajp.port:${ajp_port}/g' ${dirname}/standalone/configuration/${config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    onlyif  => "grep 'jboss.ajp.port:8009' ${dirname}/standalone/configuration/${config}",
    require => Exec["tar ${install_file} in /var/tmp"],
    before  => Service['wildfly'],
  }

  file{"${dirname}/standalone/configuration/mgmt-users.properties":
    ensure  => present,
    mode    => '0755',
    owner   => $user,
    group   => $group,
    content => template('wildfly/mgmt-users.properties.erb'),
    require => Exec["tar ${install_file} in /var/tmp"],
    before  => Service['wildfly'],
  }

  file{'/etc/init.d/wildfly':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template("wildfly/${service_file}"),
  }

  file{'/etc/default/wildfly':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('wildfly/wildfly.conf.erb'),
  }

  service { 'wildfly':
    ensure  => true,
    name    => 'wildfly',
    enable  => true,
    require => [File['/etc/init.d/wildfly'],File['/etc/default/wildfly'],
                Exec["tar ${install_file} in /var/tmp"],]
  }

}
