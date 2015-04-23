#
# Adds SSL to a connector
#
define wildfly::standalone::web::ssl($connector = undef, $name = undef, $password = undef, $protocol = undef, $key_alias = undef, $certificate_key_file = undef) {

  $params = {
    'name' => $name,
    'password' => $password,
    'protocol' => $protocol,
    'key-alias' => $key_alias,
    'ceritificate-key-file' => $certificate_key_file
  }

  wildfly::util::cli { "/subsystem=web/connector=${connector}/ssl=configuration":
    content => $params
  }

}