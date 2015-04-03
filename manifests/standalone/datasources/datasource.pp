#
# Configures a datasource
#
define wildfly::standalone::datasources::datasource($name = undef, $config = undef) {

  wildfly::util::cli { "Adding ${title}":
    content => $config,
    path    => "/subsystem=datasources/data-source=${name}"
  }
  ->
  wildfly::util::exec_cli { "Enable ${name}":
    action_command => "/subsystem=datasources/data-source=${name}:enable",
    verify_command => "/subsystem=datasources/data-source=${name}:read-resource",
    condition      => '"enabled" => true'
  }

}