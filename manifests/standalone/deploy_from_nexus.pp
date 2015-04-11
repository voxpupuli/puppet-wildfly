#
# Deploy from Nexus
#
define wildfly::standalone::deploy_from_nexus($gav = undef, $packaging = undef, $repository = 'public') {

  nexus::artifact { $title:
    gav        => $gav,
    packaging  => $packaging,
    repository => $repository,
    output     => "/tmp/${title}"
  }
  ->
  exec { "Deploy ${title}":
    command => "ruby deploy.rb ${file_name}",
    unless  => "ruby deploy.rb ${file_name} --verify-only",
    cwd     => "${wildfly::dirname}/bin",
    path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin', "${wildfly::dirname}/bin"],
    require => Service['wildfly']
  }

}