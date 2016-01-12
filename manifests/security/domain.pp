# This is a defined resource type for creating a security domain
# Please also see: https://docs.jboss.org/author/display/WFLY9/Security+subsystem+configuration
#
# [*domain_name*]
#  Name of the security domain to be created on the Wildfly server.
#
# [*code*]
#  Login module code to use. See: https://docs.jboss.org/author/display/WFLY9/Authentication+Modules
#
# [*flag*]
#  The flag controls how the module participates in the overall procedure. Allowed values are:
#  `requisite`, `required`, `sufficient` or `optional`. Default: `required`.
#
# [*module_options*]
#  A hash of module options containing name/value pairs. E.g.:
#  `{ 'name1' => 'value1', 'name2' => 'value2' }`
#  or in Hiera:
#  ```
#   module_options:
#    name1: value1
#    name2: value2
#  ```
#
define wildfly::security::domain(
  $domain_name    = $title,
  $code           = undef,
  $flag           = 'required',
  $module_options = {}
) {

  wildfly::util::resource { "/subsystem=security/security-domain=${domain_name}":
    content => {
      'cache-type' => 'default',
    },
  } ->

  wildfly::util::resource { "/subsystem=security/security-domain=${domain_name}/authentication=classic":
    content => {},
  } ->

  wildfly::util::resource { "/subsystem=security/security-domain=${domain_name}/authentication=classic/login-module=${code}":
    content => {
      'code'           => $code,
      'flag'           => $flag,
      'module-options' => $module_options,
    },
  }

}