#
# Uses Wildfly CLI Wrapper to ensure configuration state
#
define wildfly::util::cli($content = undef, $path = undef) {

  $json_content = to_unescaped_json($content)

  exec { $title:
    command => "java -jar ${wildfly::dirname}/bin/client/wildfly-cli-wrapper.jar \"${path}\" ${json_content}",
    path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin', "${wildfly::java_home}/bin"],
    require => Service['wildfly']
  }

}