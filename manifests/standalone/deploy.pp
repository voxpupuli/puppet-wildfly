#
# Deploy $source to Wildfly
#
define wildfly::standalone::deploy($ensure = present, $source = undef, $checksum = undef) {

  $file_name = inline_template('<%= File.basename(URI::parse(@source).path) %>')
  $local_source = "/tmp/${file_name}"

  if ( $checksum == undef ) {
    archive { $local_source:
      source => $source
    }
  } else {
    archive { $local_source:
      source        => $source,
      checksum      => $checksum,
      checksum_type => 'sha1'
    }
  }

  file { $local_source:
    owner   => $::wildfly::user,
    group   => $::wildfly::group,
    mode    => '0755',
    require => Archive[$local_source],
    notify  => Wildfly_deploy[$name]
  }

  wildfly_deploy { $name:
    ensure   => $ensure,
    username => $::wildfly::users_mgmt['wildfly']['username'],
    password => $::wildfly::users_mgmt['wildfly']['password'],
    host     => $::wildfly::mgmt_bind,
    port     => $::wildfly::mgmt_http_port,
    source   => "file:${local_source}"
  }

}