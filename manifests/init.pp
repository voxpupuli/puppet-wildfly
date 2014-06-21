# == Class: wildfly
#
class wildfly(
   $version        = '8.1.0',
   $install_source = undef,
   $install_file   = undef,
   $java_home      = undef,
) inherits wildfly::params {

  require wildfly::install

}
