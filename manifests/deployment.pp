#
# Manages a Wildfly deployment
#
define wildfly::deployment(
  $source,
  $ensure            = present,
  $timeout           = undef,
  $server_group      = undef,
  $operation_headers = {}) {

  require wildfly::install

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
      mode   => '0755',
    }
  }

  wildfly_deployment { $name:
    ensure            => $ensure,
    server_group      => $server_group,
    username          => $wildfly::mgmt_user['username'],
    password          => $wildfly::mgmt_user['password'],
    host              => $::wildfly::mgmt_bind,
    port              => $::wildfly::mgmt_http_port,
    timeout           => $timeout,
    source            => "file:${local_source}",
    operation_headers => $operation_headers,
    require           => File[$local_source]
  }

}
