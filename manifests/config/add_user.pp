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
  $password_hash = inline_template('<%= require \'digest/md5\'; Digest::MD5.hexdigest("#{@username}:#{@realm}:#{@password}") %>')

  file_line { "${username}:${realm}":
    path  => "${wildfly::dirname}/${wildfly::mode}/configuration/${file_name}",
    line  => "${username}=${password_hash}",
    match => "^${username}=.*\$"
  }
}