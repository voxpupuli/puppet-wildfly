#
# Deploy $source or nexus artifact ($gav, $nexus_url, $repository) to Wildfly
#
define wildfly::deploy(
  $ensure            = present,
  $package_temp_path = '/tmp',
  $packaging         = 'jar',
  $checksum_type     = 'sha1',
  $timeout           = undef,
  $server_group      = undef,
  $checksum          = undef,
  $classifier        = undef,
  $extension         = undef,
  $source            = undef,
  $nexus_url         = undef,
  $gav               = undef,
  $repository        = undef) {

  if ( $source == undef) {
    fail('deploy.pp:20 - No nexus support in this version.')
    # $artifact_id = values_at(split($gav,  ':'), 1)
    # $local_source = "${package_temp_path}/${artifact_id}.${packaging}"
    #
    # archive::nexus { $local_source:
    #   ensure     => present,
    #   url        => $nexus_url,
    #   gav        => $gav,
    #   repository => $repository,
    #   packaging  => $packaging,
    #   owner      => $::wildfly::user,
    #   group      => $::wildfly::group,
    #   notify     => Wildfly_deploy[$name]
    # }

  } else {

    $file_name = inline_template('<%= File.basename(URI::parse(@source).path) %>')
    $local_source = "${package_temp_path}/${file_name}"
    package {'curl': ensure => present, }
    exec {"curl ${source}":
      command  => "curl -s -S -L -o ${local_source} '${source}'",
      path     => $::path,
      loglevel => 'notice',
      creates  => $local_source,
      require  => Package[curl],
    }
    file { $local_source:
      owner   => $::wildfly::user,
      group   => $::wildfly::group,
      mode    => '0755',
      require => Exec["curl ${source}"],
      notify  => Wildfly_deploy[$name]
    }

  }

  wildfly_deploy { $name:
    ensure       => $ensure,
    server_group => $server_group,
    username     => $::wildfly::users_mgmt['wildfly']['username'],
    password     => $::wildfly::users_mgmt['wildfly']['password'],
    host         => $::wildfly::mgmt_bind,
    port         => $::wildfly::mgmt_http_port,
    timeout      => $timeout,
    source       => "file:${local_source}"
  }

}
