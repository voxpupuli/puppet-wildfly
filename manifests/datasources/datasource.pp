#
# Configures a datasource
#
define wildfly::datasources::datasource(
  $config = undef,
  $target_profile = undef) {

  $profile_path = profile_path($target_profile)

  wildfly::resource { "/subsystem=datasources/data-source=${name}":
    content => $config,
    profile => $target_profile
  }
  ->
  wildfly::cli { "Enable ${name}":
    command => "${profile_path}/subsystem=datasources/data-source=${name}:enable",
    unless  => "(result == true) of ${profile_path}/subsystem=datasources/data-source=${name}:read-attribute(name=enabled)",
  }

}
