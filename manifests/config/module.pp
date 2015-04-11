#
# Module installation
#
define wildfly::config::module($file_uri = undef, $dependencies = []) {

  $file_name = file_name_from_url($file_uri)

  wget::fetch { "Downloading module ${title}":
    source      => $file_uri,
    destination => "/opt/${file_name}",
    cache_dir   => '/var/cache/wget',
    cache_file  => $file_name,
    notify      => Exec["Create Parent Directories: ${title}"]
  }

  $namespace_path = regsubst($title, '[.]', '/', 'G')

  File {
    owner => $wildfly::user,
    group => $wildfly::group
  }

  $dir_path = "${wildfly::dirname}/modules/system/layers/base/${namespace_path}/main"

  exec { "Create Parent Directories: ${title}":
    path    => ['/bin','/usr/bin', '/sbin'],
    command => "/bin/mkdir -p ${dir_path}",
    unless  => "test -d ${dir_path}",
    before  => [File[$dir_path]],
  }

  file { $dir_path:
    ensure  => directory,
  }

  file { "${dir_path}/${file_name}":
    ensure => file,
    source => "/opt/${file_name}"
  }

  file { "${dir_path}/module.xml":
    ensure  => file,
    content => template('wildfly/module.xml.erb')
  }

}
