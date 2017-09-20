#
define wildfly::security::user_role_mapping (
  $role,
  $username = $title,
  $realm = undef,
  $create_role = false,
){

  $_username = upcase($username)

  if $create_role {
    wildfly::resource { "/core-service=management/access=authorization/role-mapping=${role}":
      before => Wildfly::Resource["/core-service=management/access=authorization/role-mapping=${role}/include=user-${_username}"],
    }
  }
  wildfly::resource { "/core-service=management/access=authorization/role-mapping=${role}/include=user-${_username}":
    content => {
      'name'  => $username,
      'realm' => $realm,
      'type'  => 'USER',
    },
  }
}
