#
# Module installation
#
define wildfly::config::module($file_uri = undef, $dependencies = []) {

  $namespace_path = regsubst($name, '[.]', '/', 'G')

  File {
    owner => $wildfly::user,
    group => $wildfly::group
  }

  $dir_path = "${wildfly::dirname}/modules/system/layers/base/${namespace_path}/main"

  exec { "Create Parent Directories: ${name}":
    path    => ['/bin','/usr/bin', '/sbin'],
    command => "/bin/mkdir -p ${dir_path}",
    unless  => "test -d ${dir_path}",
    before  => [File[$dir_path]],
  }

  file { $dir_path:
    ensure  => directory,
  }

  $file_name = inline_template('<%= File.basename(URI::parse(@file_uri).path) %>')

  archive { "${dir_path}/${file_name}":
    source        => $file_uri,
  }

  file { "${dir_path}/module.xml":
    ensure  => file,
    content => template('wildfly/module.xml.erb')
  }

}
