#
# Associate roles to user
#

define wildfly::config::user_roles($roles) {

  file_line { "${title}:${roles}":
    path   => "${wildfly::dirname}/${wildfly::mode}/configuration/application-roles.properties",
    line   => "${title}=${roles}",
    match  => "^${title}=.*\$",
    notify => Service['wildfly'],
  }

}
