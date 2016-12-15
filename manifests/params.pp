#
# Wildfly default params class
#
class wildfly::params {

  $manage_user    = true
  $uid            = undef
  $gid            = undef
  $group          = 'wildfly'
  $user           = 'wildfly'
  $dirname        = '/opt/wildfly'
  $package_ensure = 'present'

  $install_method   = 'tarball'
  $package_name     = 'wildfly'
  $package_version  = present

  $service_ensure    = true
  $service_enable    = true
  $conf_file         = undef
  $service_file      = undef
  $service_name      = undef
  $conf_template     = undef
  $systemd_template  = undef
  $custom_init       = undef
  $init_system       = $::initsystem
  $java_home         = '/usr/java/default/'
  $mode              = 'standalone'
  $config            = 'standalone.xml'
  $domain_config     = 'domain.xml'
  $host_config       = 'host.xml'
  $console_log       = '/var/log/wildfly/console.log'

  $mode_template     = "wildfly/${mode}.conf.erb"

  $properties = {
    'jboss.bind.address' => '0.0.0.0',
    'jboss.bind.address.management' => '127.0.0.1',
    'jboss.management.http.port' => '9990',
    'jboss.management.https.port' => '9993',
    'jboss.http.port' => '8080',
    'jboss.https.port' => '8443',
    'jboss.ajp.port' => '8009',
  }

  $java_xmx          = '512m'
  $java_xms          = '128m'
  $java_maxpermsize  = '256m'
  $java_opts         = ''
  $jboss_opts        = ''

  $mgmt_user = {
    username => 'puppet',
    password => fqdn_rand_string(30)
  }

  $install_cache_dir = '/var/cache/wget'
  $install_download_timeout = 500
  $remote_debug      = false
  $remote_debug_port = '8787'
  $startup_wait      = '30'
  $shutdown_wait     = '30'

  $secret_value      = undef

}
