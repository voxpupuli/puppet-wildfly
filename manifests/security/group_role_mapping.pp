#
define wildfly::security::group_role_mapping(
  $role,
  $group = $title,
  $realm = undef,
  $create_role = false,
){

  $_group = upcase($group)

  if $create_role {
    wildfly::resource { "/core-service=management/access=authorization/role-mapping=${role}":
      before => Wildfly::Resource["/core-service=management/access=authorization/role-mapping=${role}/include=group-${_group}"],
    }
  }
  wildfly::resource { "/core-service=management/access=authorization/role-mapping=${role}/include=group-${_group}":
    content => {
      'name'  => $group,
      'realm' => $realm,
      'type'  => 'GROUP',
    },
  }
}
