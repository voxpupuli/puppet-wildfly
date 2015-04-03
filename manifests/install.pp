#
# wildfly install class
#
class wildfly::install  {

  $install_file = file_name_from_url($wildfly::install_source)

  wget::fetch { "Retrieve ${wildfly::install_source} in /var/tmp":
    source      => $wildfly::install_source,
    destination => "/var/tmp/${install_file}",
    cache_dir   => '/var/cache/wget',
    cache_file  => $install_file,
    notify      => Exec["tar ${install_file} in /var/tmp"]
  }

  exec { "tar ${install_file} in /var/tmp":
    command => "tar xzf ${install_file} -C ${wildfly::dirname} --strip 1",
    cwd     => '/var/tmp',
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    creates => "${wildfly::dirname}/jboss-modules.jar",
    user    => $wildfly::user,
    group   => $wildfly::group,
  }

  file { "${wildfly::dirname}/bin/client/wildfly-cli-wrapper.jar":
    ensure  => file,
    owner   => $wildfly::user,
    group   => $wildfly::group,
    content => file('wildfly/wildfly-cli-wrapper-0.0.1.jar'),
    mode    => '0755',
    require => Exec["tar ${install_file} in /var/tmp"]
  }

}