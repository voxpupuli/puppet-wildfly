#
# Change wildfly sockets configuration
#
define wildfly::config::socket_binding(
  $port = undef
) {

  augeas { $title:
    lens    => 'Xml.lns',
    incl    => "${wildfly::dirname}/${wildfly::mode}/configuration/${wildfly::config}",
    changes => "set server/socket-binding-group/socket-binding[#attribute/name='${title}']/#attribute/port ${port}",
    onlyif  => "match server/socket-binding-group/socket-binding[#attribute/name='${title}'][#attribute/port='${port}'] size == 0"
  }

}
