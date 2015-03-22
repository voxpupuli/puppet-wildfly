#
# Add wildfly management user
#
define wildfly::config::add_mgmt_user(
  $username = undef,
  $password = undef
)
{

  wildfly::config::add_user { $title:
    username  => $username,
    password  => $password,
    file_name => 'mgmt-users.properties',
    realm     => 'ManagementRealm'
  }
}