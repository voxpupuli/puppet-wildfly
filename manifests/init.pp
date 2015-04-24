#
# wildfly module class
#
class wildfly(
  $version           = '8.2.0',
  $install_source    = 'http://download.jboss.org/wildfly/8.2.0.Final/wildfly-8.2.0.Final.tar.gz',
  $java_home         = $wildfly::params::java_home,
  $group             = $wildfly::params::group,
  $user              = $wildfly::params::user,
  $dirname           = $wildfly::params::dirname,
  $mode              = $wildfly::params::mode,
  $config            = $wildfly::params::config,
  $console_log       = $wildfly::params::console_log,
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
