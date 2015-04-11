#
# Deploy from a URL
#
define wildfly::standalone::deploy_from_url() {

  $file_name = file_name_from_url($title)

  wget::fetch { "Download deployable ${file_name}":
    source      => $title,
    destination => "/tmp/${file_name}",
    cache_dir   => '/var/cache/wget',
    cache_file  => $file_name,
    notify      => Exec["Deploy ${title}"]
  }

  exec { "Deploy ${title}":
    command => "ruby deploy.rb ${file_name}",
    unless  => "ruby deploy.rb ${file_name} --verify-only",
    cwd     => "${wildfly::dirname}/bin",
    path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin', "${wildfly::dirname}/bin"],
    require => Service['wildfly']
  }

}