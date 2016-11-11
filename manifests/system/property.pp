#
# Configures a system property
#
define wildfly::system::property(
  $value = undef,
  $target_profile = undef) {

  $params = {
    'value' => $value,
  }

  wildfly::resource { "/system-property=${name}":
    content => $params,
    profile => $target_profile,
  }

}
