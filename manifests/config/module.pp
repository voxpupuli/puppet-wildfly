#
# Module installation
#
define wildfly::config::module($system = true, $source = undef, $dependencies = []) {

  require wildfly::install

  $namespace_path = regsubst($name, '[.]', '/', 'G')

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
    unless  => "/bin/ls -d ${dir_path}",
    before  => [File[$dir_path]],
  }

  file { $dir_path:
    ensure  => directory,
  }

  $file_name = inline_template('<%= File.basename(URI::parse(@source).path) %>')

  exec {"curl ${source}":
    command  => "/usr/bin/curl -s -S -L -o ${dir_path}/${file_name} '${source}'",
    path     => $::path,
    loglevel => 'notice',
    creates  => "${dir_path}/${file_name}",
    require  => [ Package[curl], File[$wildfly::dirname] ],
  }

  file { "${dir_path}/${file_name}":
    owner => $::wildfly::user,
    group => $::wildfly::group,
    mode  => '0755',
    require => Exec["curl ${source}"],
  }

  file { "${dir_path}/module.xml":
    ensure  => file,
    content => template('wildfly/module.xml.erb')
  }

}
