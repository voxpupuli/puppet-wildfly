class wildfly::setup {

  create_resources(wildfly::config::add_mgmt_user, $wildfly::users_mgmt)
  
  # default JAVA_OPTS="-Xms64m -Xmx512m -XX:MaxPermSize=256m
  exec { 'replace memory parameters':
    command => "sed -i -e's/\\-Xms.*m \\-Xmx.*m \\-XX:MaxPermSize=.*m/\\-Xms${wildfly::java_xms} \\-Xmx${wildfly::java_xmx} \\-XX:MaxPermSize=${wildfly::java_maxpermsize}/g' ${wildfly::dirname}/bin/${wildfly::mode}.conf",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    unless  => "grep '\\-Xms${wildfly::java_xms} \\-Xmx${wildfly::java_xmx} \\-XX:MaxPermSize=${wildfly::java_maxpermsize}' ${wildfly::dirname}/bin/${wildfly::mode}.conf"
  }

  Exec['replace management bind'] ->
    Exec['replace public bind'] ->
      Exec['replace management http port'] ->
        Exec['replace management https port'] ->
          Exec['replace http port'] ->
            Exec['replace https port'] ->
              Exec['replace ajp port']

  exec { 'replace management bind':
    command => "sed -i -e's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:${wildfly::mgmt_bind}/g' ${wildfly::dirname}/standalone/configuration/${wildfly::config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    onlyif  => "grep 'jboss.bind.address.management:127.0.0.1' ${wildfly::dirname}/standalone/configuration/${wildfly::config}",
  }

  exec { 'replace public bind':
    command => "sed -i -e's/jboss.bind.address:127.0.0.1/jboss.bind.address:${wildfly::public_bind}/g' ${wildfly::dirname}/standalone/configuration/${wildfly::config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    onlyif  => "grep 'jboss.bind.address:127.0.0.1' ${wildfly::dirname}/standalone/configuration/${wildfly::config}"
  }

  exec { 'replace management http port':
    command => "sed -i -e's/jboss.management.http.port:9990/jboss.management.http.port:${wildfly::mgmt_http_port}/g' ${wildfly::dirname}/standalone/configuration/${wildfly::config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    unless  => "grep 'jboss.management.http.port:${wildfly::mgmt_http_port}' ${wildfly::dirname}/standalone/configuration/${wildfly::config}"
  }

  exec { 'replace management https port':
    command => "sed -i -e's/jboss.management.https.port:9993/jboss.management.https.port:${wildfly::mgmt_https_port}/g' ${wildfly::dirname}/standalone/configuration/${wildfly::config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    unless  => "grep 'jboss.management.https.port:${wildfly::mgmt_https_port}' ${wildfly::dirname}/standalone/configuration/${wildfly::config}"
  }

  exec { 'replace http port':
    command => "sed -i -e's/jboss.http.port:8080/jboss.http.port:${wildfly::public_http_port}/g' ${wildfly::dirname}/standalone/configuration/${wildfly::config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    unless  => "grep 'jboss.http.port:${wildfly::public_http_port}' ${wildfly::dirname}/standalone/configuration/${wildfly::config}"
  }

  exec { 'replace https port':
    command => "sed -i -e's/jboss.https.port:8443/jboss.https.port:${wildfly::public_https_port}/g' ${wildfly::dirname}/standalone/configuration/${wildfly::config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    unless  => "grep 'jboss.https.port:${wildfly::public_https_port}' ${wildfly::dirname}/standalone/configuration/${wildfly::config}"
  }

  exec { 'replace ajp port':
    command => "sed -i -e's/jboss.ajp.port:8009/jboss.ajp.port:${wildfly::ajp_port}/g' ${wildfly::dirname}/standalone/configuration/${wildfly::config}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    unless  => "grep 'jboss.ajp.port:${wildfly::ajp_port}' ${wildfly::dirname}/standalone/configuration/${wildfly::config}"
  }

}