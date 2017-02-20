#
# wildfly module class
#
class wildfly(
  String $version                                     = '9.0.2',
  Enum['wildfly', 'eap'] $distribution                = 'wildfly',
  String $install_source                              = 'http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz',
  Stdlib::Unixpath $install_cache_dir                 = '/var/cache/wget',
  Integer $install_download_timeout                   = 500,
  Stdlib::Unixpath $java_home                         = '/usr/java/default',
  Boolean $manage_user                                = true,
  String $group                                       = 'wildfly',
  String $user                                        = 'wildfly',
  Stdlib::Unixpath $dirname                           = '/opt/wildfly',
  Enum['standalone', 'domain'] $mode                  = 'standalone',
  String $mode_template                               = "wildfly/${mode}.conf.erb",
  String $config                                      = 'standalone.xml',
  String $domain_config                               = 'domain.xml',
  String $host_config                                 = 'host.xml',
  String $console_log                                 = '/var/log/wildfly/console.log',
  String $java_xmx                                    = '512m',
  String $java_xms                                    = '256m',
  String $java_maxpermsize                            = '128m',
  String $package_ensure                              = 'present',
  Boolean $service_ensure                             = true,
  Boolean $service_enable                             = true,
  Boolean $remote_debug                               = false,
  Integer $remote_debug_port                          = 8787,
  Integer $startup_wait                               = 30,
  Integer $shutdown_wait                              = 30,
  Enum['sysvinit', 'systemd', 'upstart'] $init_system = $::initsystem,
  Hash $properties                                    = {
    'jboss.bind.address' => '0.0.0.0',
    'jboss.bind.address.management' => '127.0.0.1',
    'jboss.management.http.port' => '9990',
    'jboss.management.https.port' => '9993',
    'jboss.http.port' => '8080',
    'jboss.https.port' => '8443',
    'jboss.ajp.port' => '8009',
  },
  Hash $mgmt_user                                     = {
    'username' => 'puppet',
    'password' => fqdn_rand_string(30),
  },
  Optional[String] $conf_file                         = undef,
  Optional[String] $conf_template                     = undef,
  Optional[String] $service_file                      = undef,
  Optional[String] $systemd_template                  = undef,
  Optional[String] $service_name                      = undef,
  Optional[String] $custom_init                       = undef,
  Optional[Integer] $uid                              = undef,
  Optional[Integer] $gid                              = undef,
  Optional[String] $secret_value                      = undef,
  Optional[String] $remote_username                   = undef,
  Optional[String] $package_name                      = undef,
  Optional[String] $package_version                   = undef,
  Optional[String] $java_opts                         = undef,
  Optional[String] $jboss_opts                        = undef,
) {

  include wildfly::prepare
  include wildfly::install
  include wildfly::setup
  include wildfly::service

  Class['wildfly::prepare'] ->
    Class['wildfly::install'] ->
      Class['wildfly::setup'] ->
        Class['wildfly::service']
}
