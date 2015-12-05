#
# wildfly install class
#
class wildfly::install  {

  $install_source = $wildfly::install_source

  $install_file = inline_template('<%=File.basename(URI::parse(@install_source).path)%>')

  # Download Wildfly from jboss.org
  exec { "Download wildfly from ${install_source}":
    command  => "/usr/bin/wget -N -P /var/cache/wget ${install_source} --max-redirect=5",
    path     => ['/bin', '/usr/bin', '/sbin'],
    loglevel => 'notice',
    creates  => "/var/cache/wget/${install_file}",
    unless   => "test -f ${wildfly::dirname}/jboss-modules.jar",
    timeout  => 500,
  }
  ~>
  # Gunzip+Untar wildfly.tar.gz if download was successful.
  exec { "untar ${install_file}":
    command  => "tar --no-same-owner --no-same-permissions --strip-components=1 -C ${wildfly::dirname} -zxvf /var/cache/wget/${install_file}",
    path     => ['/bin', '/usr/bin', '/sbin'],
    loglevel => 'notice',
    creates  => "${wildfly::dirname}/jboss-modules.jar",
    user     => $wildfly::user,
    group    => $wildfly::group,
  }

}
