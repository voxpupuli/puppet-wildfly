#
# Wildfly startup service class
#
class wildfly::service {

  file{ '/etc/default/wildfly.conf':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('wildfly/wildfly.conf.erb'),
  }

  file{ '/etc/init.d/wildfly':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => "${wildfly::dirname}/bin/init.d/${wildfly::service_file}",
  }

  service { 'wildfly':
    ensure     => true,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [File['/etc/init.d/wildfly'],File['/etc/default/wildfly.conf']]
  }

}