# Converts a LIST of STRINGs and OBJECTs into an OBJECT of OBJECTs.
#
# @param elements LIST of STRINGs or OBJECTS to be converted.
# @return [Hash[Hash, Hash]] returns a Hash of OBJECTs.
function wildfly::objectify(Array[Variant[String, Hash]] $elements) {

  $objectified = $elements.map |$element| {

    if $element.is_a(String) {
      [$element, {}]
    } else {
      $element.map |$key, $value| { [$key, $value] }
    }

  }

  hash($objectified)
}
