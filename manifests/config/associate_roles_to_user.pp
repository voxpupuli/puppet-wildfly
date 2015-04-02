#
# Associate roles to user
#

define wildfly::config::associate_roles_to_user($username = undef, $roles = undef) {

  file_line { "${username}:${roles}":
    path  => "${wildfly::dirname}/${wildfly::mode}/configuration/application-roles.properties",
    line  => "${username}=${roles}",
    match => "^${username}=.*\$"
  }

}