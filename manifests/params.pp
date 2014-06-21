#
#
class wildfly::params {

  $wildfly_group   = 'wildfly'
  $wildfly_user    = 'wildfly'
  $wildfly_dirname = '/opt/wildfly'

  $wildfly_service_file  = $::osfamily? {
    Debian => 'wildfly-init-debian.sh.erb',
    RedHat => 'wildfly-init-redhat.sh.erb',
  }

  # => Wildfly Deployment Type (standalone or domain)
  $wildfly_mode = 'standalone'

  # => Standalone Mode Configuration
  # => (standalone/ha.xml, standalone-full/ha/ha-aws.xml)
  $wildfly_config = 'standalone-full.xml'

}