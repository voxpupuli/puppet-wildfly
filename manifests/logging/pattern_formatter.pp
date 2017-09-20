#
#
#

define wildfly::logging::pattern_formatter (
  $color_map      = undef,
  $pattern        = undef,
){
  wildfly::resource { "/subsystem=logging/pattern-formatter=${title}":
    content => {
      'color-map' => $color_map,
      'pattern'   => $pattern
    },
  }
}
