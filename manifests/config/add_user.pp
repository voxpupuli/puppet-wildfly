#
# add wildlfy user
#
define wildfly::config::add_user(
  $username  = undef,
  $password  = undef,
  $file_name = undef,
  $realm     = undef
)
{
  $password_hash = password_hash($username, $password, $realm)

  file_line { "${username}:${realm}":
    path  => "${wildfly::dirname}/${wildfly::mode}/configuration/${file_name}",
    line  => "${username}=${password_hash}",
    match => "^${username}=.*\$"
  }
}