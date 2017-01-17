#
# Associate groups to user
#
define wildfly::config::user_groups($groups) {

  file_line { "${title}:${groups}":
    path   => "${wildfly::dirname}/${wildfly::mode}/configuration/mgmt-groups.properties",
    line   => "${title}=${groups}",
    match  => "^${title}=.*\$",
    notify => Service['wildfly'],
  }

}
