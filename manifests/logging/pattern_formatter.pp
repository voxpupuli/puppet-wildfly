#
#
#

define wildfly::logging::pattern_formatter (
  $color_map      = undef,
  $pattern        = undef,
  $target_profile = undef,
){
  wildfly::resource { "/subsystem=logging/pattern-formatter=${title}":
    content => {
      'color-map' => $color_map,
      'pattern'   => $pattern
    },
    target_profile => undef,
  }
}
