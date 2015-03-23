#
# Change wildfly interface configuration
#
define wildfly::config::interfaces(
  $inet_address_value = undef
)
{
  augeas { $title:
    lens    => 'Xml.lns',
    incl    => $wildfly::config_file_path,
    changes => "set server/interfaces/interface[#attribute/name='${title}']/inet-address/#attribute/value ${inet_address_value}",
    onlyif  => "match server/interfaces/interface[#attribute/name='${title}']/inet-address[#attribute/value='${inet_address_value}'] size == 0"
  }
}