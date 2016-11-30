#
# wildfly module class
#
class wildfly(
  $version                      = '9.0.2',
  $distribution                 = 'wildfly',
  $install_source               = 'http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz',
  $install_cache_dir            = $wildfly::params::install_cache_dir,
  $install_download_timeout     = $wildfly::params::install_download_timeout,
  $java_home                    = $wildfly::params::java_home,
  $manage_user                  = $wildfly::params::manage_user,
  $uid                          = $wildfly::params::uid,
  $gid                          = $wildfly::params::gid,
  $group                        = $wildfly::params::group,
  $user                         = $wildfly::params::user,
  $dirname                      = $wildfly::params::dirname,
  $mode                         = $wildfly::params::mode,
  $mode_template                = $wildfly::params::mode_template,
  $config                       = $wildfly::params::config,
  $domain_config                = $wildfly::params::domain_config,
  $host_config                  = $wildfly::params::host_config,
  $domain_controller_only       = $wildfly::params::domain_controller_only,
  $console_log                  = $wildfly::params::console_log,
  $java_xmx                     = $wildfly::params::java_xmx,
  $java_xms                     = $wildfly::params::java_xms,
  $java_maxpermsize             = $wildfly::params::java_maxpermsize,
  $java_opts                    = $wildfly::params::java_opts,
  $mgmt_bind                    = $wildfly::params::mgmt_bind,
  $public_bind                  = $wildfly::params::public_bind,
  $mgmt_http_port               = $wildfly::params::mgmt_http_port,
  $mgmt_https_port              = $wildfly::params::mgmt_https_port,
  $public_http_port             = $wildfly::params::public_http_port,
  $public_https_port            = $wildfly::params::public_https_port,
  $ajp_port                     = $wildfly::params::ajp_port,
  $users_mgmt                   = $wildfly::params::users_mgmt,
  $init_system                  = $wildfly::params::init_system,
  $conf_file                    = $wildfly::params::conf_file,
  $package_ensure               = $wildfly::params::package_ensure,
  $conf_template                = $wildfly::params::conf_template,
  $service_file                 = $wildfly::params::service_file,
  $systemd_template             = $wildfly::params::systemd_template,
  $service_name                 = $wildfly::params::service_name,
  $service_ensure               = $wildfly::params::service_ensure,
  $service_enable               = $wildfly::params::service_enable,
  $domain_slave                 = $wildfly::params::domain_slave,
  $custom_init                  = $wildfly::params::custom_init,
  $remote_debug                 = $wildfly::params::remote_debug,
  $remote_debug_port            = $wildfly::params::remote_debug_port,
  $startup_wait                 = $wildfly::params::startup_wait,
  $shutdown_wait                = $wildfly::params::shutdown_wait,
) inherits wildfly::params {

  include wildfly::prepare
  include wildfly::install
  include wildfly::setup
  include wildfly::service

  Class['wildfly::prepare'] ->
    Class['wildfly::install'] ->
      Class['wildfly::setup'] ->
        Class['wildfly::service']
}
