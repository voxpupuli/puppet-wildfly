class wildfly::setup {

  create_resources(wildfly::config::add_mgmt_user, $wildfly::users_mgmt)

  # default JAVA_OPTS="-Xms64m -Xmx512m -XX:MaxPermSize=256m
  exec { 'replace memory parameters':
    command => "sed -i -e's/\\-Xms.*m \\-Xmx.*m \\-XX:MaxPermSize=.*m/\\-Xms${wildfly::java_xms} \\-Xmx${wildfly::java_xmx} \\-XX:MaxPermSize=${wildfly::java_maxpermsize}/g' ${wildfly::dirname}/bin/${wildfly::mode}.conf",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    unless  => "grep '\\-Xms${wildfly::java_xms} \\-Xmx${wildfly::java_xmx} \\-XX:MaxPermSize=${wildfly::java_maxpermsize}' ${wildfly::dirname}/bin/${wildfly::mode}.conf"
  }

  # interfaces
  wildfly::config::interfaces { 'public':
    inet_address_value => "\${jboss.bind.address:${wildfly::public_bind}}"
  }

  wildfly::config::interfaces { 'management':
    inet_address_value => "\${jboss.bind.address.management:${wildfly::mgmt_bind}}"
  }

  # socket binding, replace with create_resources and a hash
  wildfly::config::socket_binding { 'management-http':
    port => "\${jboss.management.http.port:${wildfly::mgmt_http_port}}"
  }

  wildfly::config::socket_binding { 'management-https':
    port => "\${jboss.management.https.port:${wildfly::mgmt_https_port}}"
  }

  wildfly::config::socket_binding { 'http':
    port => "\${jboss.http.port:${wildfly::public_http_port}}"
  }

  wildfly::config::socket_binding { 'https':
    port => "\${jboss.https.port:${wildfly::public_https_port}}"
  }

  wildfly::config::socket_binding { 'ajp':
    port => "\${jboss.ajp.port:${wildfly::ajp_port}}"
  }

}