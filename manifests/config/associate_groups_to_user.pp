#
# Associate groups to user
#
define wildfly::config::associate_groups_to_user($username = undef, $groups = undef) {

  file_line { "${username}:${groups}":
    path  => "${wildfly::dirname}/${wildfly::mode}/configuration/mgmt-groups.properties",
    line  => "${username}=${groups}",
    match => "^${username}=.*\$"
  }

}