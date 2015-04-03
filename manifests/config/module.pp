#
# Install a module from a tar.gz package.
# The package should contain the structured module.
# For PostgreSQL module: org/postgresl/main directory with module.xml and its jars
#
define wildfly::config::module($file_uri = undef) {

  $file_name = file_name_from_url($file_uri)

  wget::fetch { "Downloading module ${title}":
    source      => $file_uri,
    destination => "/opt/${file_name}",
    cache_dir   => '/var/cache/wget',
    cache_file  => $file_name,
    notify      => Exec["Extract module ${title}"]
  }

  $module_path = regsubst($title, '[.]', '/', 'G')

  exec { "Extract module ${title}":
    command => "tar -xzf /opt/${file_name}",
    cwd     => "${wildfly::dirname}/modules/system/layers/base",
    creates => "${wildfly::dirname}/modules/system/layers/base/${module_path}/main/module.xml",
    group   => $wildfly::group,
    user    => $wildfly::user,
    path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin']
  }

}