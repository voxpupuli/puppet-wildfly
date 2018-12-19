#
# Configures a datasource
#
define wildfly::datasources::datasource(
  $ensure = undef,
  $config = undef,
  $target_profile = undef) {

  $profile_path = profile_path($target_profile)

  wildfly::resource { "/subsystem=datasources/data-source=${title}":
    ensure  => $ensure,
    content => $config,
    profile => $target_profile
  }

  if ($ensure != 'absent') {
    wildfly::cli { "Enable ${title}":
      command => "${profile_path}/subsystem=datasources/data-source=${title}:enable",
      unless  => "(result == true) of ${profile_path}/subsystem=datasources/data-source=${title}:read-attribute(name=enabled)",
    }
  }

}
