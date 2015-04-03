#
# Configures a topic
#
define wildfly::standalone::messaging::topic($entries = undef) {

  $params = {
    'entries' => $entries
  }

  wildfly::util::cli { $title:
    content => $params,
    path    => "/subsystem=messaging/hornetq-server=default/jms-topic=${title}"
  }

}