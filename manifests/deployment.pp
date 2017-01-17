#
# Manages a Wildfly deployment
#
define wildfly::deployment(
  $source,
  $ensure            = present,
  $timeout           = undef,
  $server_group      = undef,
  $operation_headers = {}) {

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
    exec { "download deployable from ${source}":
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
      mode   => '0655',
    }
  }

  wildfly_deployment { $title:
    ensure            => $ensure,
    server_group      => $server_group,
    username          => $wildfly::mgmt_user['username'],
    password          => $wildfly::mgmt_user['password'],
    host              => $wildfly::setup::properties['jboss.bind.address.management'],
    port              => $wildfly::setup::properties['jboss.management.http.port'],
    timeout           => $timeout,
    source            => $local_source,
    operation_headers => $operation_headers,
    require           => [Service['wildfly'], File[$local_source]],
  }

}
