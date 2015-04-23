#
# Configures a datasource
#
define wildfly::standalone::datasources::datasource($config = undef) {

  wildfly::util::cli { "/subsystem=datasources/data-source=${name}":
    content => $config,
  }
  ->
  wildfly::util::exec_cli { "Enable ${name}":
    action_command => "/subsystem=datasources/data-source=${name}:enable",
    verify_command => "(result == true) of /subsystem=datasources/data-source=${name}:read-attribute(name=enabled)"
  }

}