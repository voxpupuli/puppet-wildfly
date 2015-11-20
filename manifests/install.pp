#
# wildfly install class
#
class wildfly::install  {

  $install_source = $wildfly::install_source

  $install_file = inline_template('<%=File.basename(URI::parse(@install_source).path)%>')

  # Download Wildfly from jboss.org
  exec {"curl ${install_source}":
    command  => "/usr/bin/curl -s -S -L -o /tmp/${install_file} '${install_source}'",
    path     => ['/bin','/usr/bin', '/sbin'],
    loglevel => 'notice',
    creates  => "/tmp/${install_file}",
    unless   => "test -f ${wildfly::dirname}/jboss-modules.jar",
    require  => [ Package[curl], File[$wildfly::dirname] ],
  }
  # Gunzip+Untar wildfly.tar.gz if curl was successful.
  exec {"untar ${install_file}":
    command  => "tar --no-same-owner --no-same-permissions --strip-components=1 -C ${wildfly::dirname} -zxvf /tmp/${install_file}",
    path     => ['/bin','/usr/bin', '/sbin'],
    loglevel => 'notice',
    creates  => "${wildfly::dirname}/jboss-modules.jar",
    require  => Exec["curl ${install_source}"],
    user     => $wildfly::user,
    group    => $wildfly::group,
  }
  # Remove wildfly.tar.gz file if extraction was successful.
  file {"/tmp/${install_file}":
    ensure  => absent,
    require => Exec["untar ${install_file}"],
  }

}
