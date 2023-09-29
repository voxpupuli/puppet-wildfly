# Default service configuration for a specific distribution, version
#   execution mode and initsystem.
#
# @param distribution Wildfly distribution: 'wildfly' or 'jboss-eap'.
# @param version Wildfly version.
# @param mode Wildfly execution mode will run, 'standalone' or 'domain'.
# @param init_system System's initsystem.
# @return [Hash[String, String]] service configuration: name, configuration file and template and bundled init scripts.
function wildfly::service_config(
  String $distribution,
  String $version,
  String $mode,
  Enum['sysvinit', 'systemd', 'upstart'] $init_system,
) {
  case $distribution {
    # intentionally not using $facts (see rspec-puppet #503)

    'wildfly': {
      $conf_file = $facts['os']['family'] ? {
        'Debian' => '/etc/default/wildfly',
        default  => '/etc/default/wildfly.conf'
      }

      $service_file = "wildfly-init-${downcase($facts['os']['family'])}.sh"

      case [versioncmp($version, '10'), $init_system] {
        [-1, default]: {
          {
            'service_name'     => 'wildfly',
            'conf_file'        => $conf_file,
            'conf_template'    => 'wildfly/wildfly.sysvinit.conf',
            'service_file'     => "bin/init.d/${service_file}",
          }
        }
        [default, 'systemd']: {
          {
            'service_name'     => 'wildfly',
            'conf_file'        => '/etc/wildfly/wildfly.conf',
            'conf_template'    => 'wildfly/wildfly.systemd.conf',
            'service_file'     => "docs/contrib/scripts/init.d/${service_file}",
            'systemd_template' => 'wildfly/wildfly.systemd.service',
          }
        }
        [default, default]: {
          {
            'service_name'     => 'wildfly',
            'conf_file'        => $conf_file,
            'conf_template'    => 'wildfly/wildfly.sysvinit.conf',
            'service_file'     => "docs/contrib/scripts/init.d/${service_file}",
          }
        }
      }
    }
    'jboss-eap': {
      case versioncmp($version, '7') {
        -1: {
          {
            'service_name'     => 'jboss-as',
            'conf_file'        => '/etc/jboss-as/jboss-as.conf',
            'conf_template'    => 'wildfly/wildfly.sysvinit.conf',
            'service_file'     => "bin/init.d/jboss-as-${mode}.sh",
          }
        }
        default: {
          {
            'service_name'     => 'jboss-eap',
            'conf_file'        => '/etc/default/jboss-eap.conf',
            'conf_template'    => 'wildfly/wildfly.sysvinit.conf',
            'service_file'     => 'bin/init.d/jboss-eap-rhel.sh',
          }
        }
      }
    }
    default: {
      fail("Unsupported distribution: ${distribution}")
    }
  }
}
