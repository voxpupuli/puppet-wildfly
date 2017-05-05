class wildfly::external_facts() {

  file { '/opt/puppetlabs/facter/facts.d/wildfly.yaml':
    ensure  => file,
    content => epp('wildfly/facts.yaml'),
  }

}
