#
# wildfly module class
#
class wildfly(
  $version           = '8.2.1',
  $install_source    = 'http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz',
  $java_home         = $wildfly::params::java_home,
  $manage_user       = $wildfly::params::manage_user,
  $uid               = $wildfly::params::uid,
  $gid               = $wildfly::params::gid,
  $group             = $wildfly::params::group,
  $user              = $wildfly::params::user,
  $dirname           = $wildfly::params::dirname,
  $mode              = $wildfly::params::mode,
  $config            = $wildfly::params::config,
  $domain_config     = $wildfly::params::domain_config,
  $host_config       = $wildfly::params::host_config,
  $console_log       = $wildfly::params::console_log,
  $java_xmx          = $wildfly::params::java_xmx,
  $java_xms          = $wildfly::params::java_xms,
  $java_maxpermsize  = $wildfly::params::java_maxpermsize,
  $java_opts         = $wildfly::params::java_opts,
  $mgmt_bind         = $wildfly::params::mgmt_bind,
  $public_bind       = $wildfly::params::public_bind,
  $mgmt_http_port    = $wildfly::params::mgmt_http_port,
  $mgmt_https_port   = $wildfly::params::mgmt_https_port,
  $public_http_port  = $wildfly::params::public_http_port,
  $public_https_port = $wildfly::params::public_https_port,
  $ajp_port          = $wildfly::params::ajp_port,
  $users_mgmt        = $wildfly::params::users_mgmt,
  $conf_file         = $wildfly::params::conf_file,
  $service_file      = $wildfly::params::service_file,
  $service_name      = $wildfly::params::service_name,
  $domain_slave      = $wildfly::params::domain_slave,
) inherits wildfly::params {

  include archive
  include wildfly::install
  include wildfly::prepare
  include wildfly::setup
  include wildfly::service

  Class['archive'] ->
    Class['wildfly::prepare'] ->
      Class['wildfly::install'] ->
        Class['wildfly::setup'] ->
          Class['wildfly::service']
}
