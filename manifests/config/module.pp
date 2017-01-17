#
# Module installation
#
define wildfly::config::module(
  $system = true,
  $source = undef,
  $dependencies = []) {

  require wildfly::install

  $namespace_path = regsubst($title, '[.]', '/', 'G')

  if $system {
    $module_dir = 'system/layers/base'
  }

  File {
    owner => $wildfly::user,
    group => $wildfly::group,
  }

  $dir_path = "${wildfly::dirname}/modules/${module_dir}/${namespace_path}/main"

  exec { "Create Parent Directories: ${title}":
    path    => ['/bin','/usr/bin', '/sbin'],
    command => "mkdir -p ${dir_path}",
    unless  => "test -d ${dir_path}",
    user    => $wildfly::user,
    before  => [File[$dir_path]],
  }

  file { $dir_path:
    ensure  => directory,
  }

  if $source == '.' {
    $file_name = '.'
  } else {
    $file_name = inline_template('<%= File.basename(URI::parse(@source).path) %>')
  }

  case $source {
    '.': {
    }
    /^(file:|puppet:)/: {
      file { "${dir_path}/${file_name}":
        ensure => 'file',
        owner  => $::wildfly::user,
        group  => $::wildfly::group,
        mode   => '0755',
        source => $source,
      }
    }
    default : {
      exec { "download module from ${source}":
        command  => "wget -N -P ${dir_path} ${source} --max-redirect=5",
        path     => ['/bin','/usr/bin', '/sbin'],
        loglevel => 'notice',
        creates  => "${dir_path}/${file_name}",
        require  => File[$wildfly::dirname],
      }

      file { "${dir_path}/${file_name}":
        ensure  => 'file',
        owner   => $::wildfly::user,
        group   => $::wildfly::group,
        mode    => '0755',
        require => Exec["download module from ${source}"],
      }
    }
  }

  file { "${dir_path}/module.xml":
    ensure  => file,
    content => template('wildfly/module.xml.erb'),
  }

}
