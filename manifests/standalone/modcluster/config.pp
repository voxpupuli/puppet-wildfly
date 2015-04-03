#
# Configures modcluster subsystem
#
define wildfly::standalone::modcluster::config($advertise_socket = 'modcluster', $connector = 'ajp', $type = 'busyness', $balancer = undef, $load_balancing_group = undef, $proxy_list = undef, $proxy_url = undef) {

  $config = {
    'advertise-socket' => $advertise_socket,
    'connector' => $connector,
    'balancer' => $balancer,
    'load-balancing-group' => $load_balancing_group,
    'proxy-url' => $proxy_url,
    'proxy-list' => $proxy_list
  }

  wildfly::util::cli { "Update mod-cluster-config: ${title}":
    content => $config,
    path => "/subsystem=modcluster/mod-cluster-config=configuration"
  }
  ->
  wildfly::util::exec_cli { "Set load-metric: ${type}":
    action_command => template('wildfly/dynamic_load_provider.cli.erb'),
    verify_command => "/subsystem=modcluster/mod-cluster-config=configuration/dynamic-load-provider=configuration/load-metric=${type}:read-resource",
    post_exec_command => 'service jboss restart'
  }

}