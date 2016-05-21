#
# Module installation
#
define wildfly::config::module($system = true, $source = undef, $dependencies = []) {

  require wildfly::install

  $namespace_path = regsubst($name, '[.]', '/', 'G')
  $namespace_first_level = split($namespace_path, '/')[0]
  $namespace_second_level = split($namespace_path, '/')[1]

  if $system {
    $module_dir = 'system/layers/base'
  }

  File {
    owner => $wildfly::user,
    group => $wildfly::group
  }

  $dir_path = "${wildfly::dirname}/modules/${module_dir}/${namespace_path}/main"

  exec { "Create Parent Directories: ${name}":
    path    => ['/bin','/usr/bin', '/sbin'],
    command => "/bin/mkdir -p ${dir_path}",
    unless  => "test -d ${dir_path}",
  } ->
  file { "${wildfly::dirname}/modules/${module_dir}/${namespace_first_level}/${namespace_second_level}":
    ensure  => directory,
    recurse => true,
  }

  $file_name = inline_template('<%= File.basename(URI::parse(@source).path) %>')

  archive { "${dir_path}/${file_name}":
    source => $source,
  }
  ->
  file { "${dir_path}/${file_name}":
    owner => $::wildfly::user,
    group => $::wildfly::group,
    mode  => '0755'
  }

  file { "${dir_path}/module.xml":
    ensure  => file,
    content => template('wildfly/module.xml.erb')
  }

}
