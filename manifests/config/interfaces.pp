#
# Change wildfly interface configuration
#
define wildfly::config::interfaces($inet_address_value){

  augeas { $name:
    lens    => 'Xml.lns',
    incl    => "${wildfly::dirname}/${wildfly::mode}/configuration/${wildfly::config}",
    changes => "set server/interfaces/interface[#attribute/name='${name}']/inet-address/#attribute/value ${inet_address_value}",
    onlyif  => "match server/interfaces/interface[#attribute/name='${name}']/inet-address[#attribute/value='${inet_address_value}'] size == 0"
  }
}