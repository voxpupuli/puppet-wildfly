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
  $service_name   = undef
  $service_ensure = true
  $service_enable = true

  $init_system       = 'systemd'

  $service_file      = undef
  $systemd_template  = undef
  $custom_init       = undef
  $conf_file         = undef
  $conf_template     = undef

  $java_home         = '/usr/java/default/'

  $mode              = 'standalone'
  $mode_template     = "wildfly/${mode}.conf.erb"
  $config            = 'standalone.xml'
  $domain_config     = 'domain.xml'
  $host_config       = 'host.xml'

  $config_file_path  = "${dirname}/${mode}/configuration/${config}"
  $console_log       = '/var/log/wildfly/console.log'

  $mgmt_bind         = '0.0.0.0'
  $mgmt_http_port    = '9990'
  $mgmt_https_port   = '9993'

  $public_bind       = '0.0.0.0'
  $public_http_port  = '8080'
  $public_https_port = '8443'

  $ajp_port          = '8009'

  $java_xmx          = '512m'
  $java_xms          = '128m'
  $java_maxpermsize  = '256m'
  $java_opts         = ''

  $users_mgmt = {
    'wildfly' => {
      password => 'wildfly',
    },
  }

  $domain_slave = {}
  $install_cache_dir = '/var/cache/wget'
  $domain_controller_only = false
  $remote_debug      = false
  $remote_debug_port = '8787'
  $startup_wait      = '30'
  $shutdown_wait     = '30'

  $install_download_timeout = 500
}
