#
# Configures system properties from a file
#
define wildfly::system::properties_file(
  $source,
  $ensure            = present) {

  $users_mgmt = keys($::wildfly::users_mgmt)
  $passwords_mgmt = values($::wildfly::users_mgmt)

  $file_name = inline_template('<%= File.basename(URI::parse(@source).path) %>')
  $local_source = "/tmp/${file_name}"

  if $source =~ /^(file:|puppet:)/ {
    file { $local_source:
      ensure => 'present',
      owner  => $::wildfly::user,
      group  => $::wildfly::group,
      mode   => '0655',
      source => $source
    }
  } else {
    exec { "download properties file from ${source}":
      command  => "wget -N -P /tmp ${source} --max-redirect=5",
      path     => ['/bin', '/usr/bin', '/sbin'],
      loglevel => 'notice',
      creates  => $local_source,
    }
    ->
    file { $local_source:
      ensure => 'present',
      owner  => $::wildfly::user,
      group  => $::wildfly::group,
      mode   => '0755',
    }
  }

  wildfly_system_properties_file { $name:
    ensure       => $ensure,
    username     => $users_mgmt[0],
    password     => $passwords_mgmt[0]['password'],
    host         => $::wildfly::mgmt_bind,
    port         => $::wildfly::mgmt_http_port,
    source       => $local_source,
    require      => File[$local_source]
  }
}
