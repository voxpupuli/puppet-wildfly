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
  $service_name   = 'wildfly'
  $service_ensure = true
  $service_enable = true

  $service_file  = $::osfamily? {
    'Debian' => 'wildfly-init-debian.sh',
    'RedHat' => 'wildfly-init-redhat.sh',
    default  => 'wildfly-init-redhat.sh',
  }

  $conf_file = $::osfamily? {
    'RedHat' => "/etc/default/${service_name}.conf",
    'Debian' => "/etc/default/${service_name}",
    default => "/etc/default/${service_name}.conf",
  }
  $conf_template     = "wildfly/${service_name}.conf.erb"

  $java_home         = '/usr/java/jdk1.7.0_75/'

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
  $custom_init  = undef
  $install_cache_dir = '/var/cache/wget'
  $remote_debug      = false
  $remote_debug_port = '8787'
  $startup_wait      = '30'
  $shutdown_wait     = '30'

  $domain_controller_only = false
}
