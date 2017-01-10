#
# Configures a queue
#
define wildfly::messaging::activemq::queue(
  $entries = undef,
  $durable = undef,
  $selector = undef,
  $target_profile = undef) {

  $params = {
    'durable' => $durable,
    'entries' => $entries,
    'selector' => $selector
  }

  wildfly::resource { "/subsystem=messaging-activemq/server=default/jms-queue=${name}":
    content => $params,
    profile => $target_profile,
  }

}
