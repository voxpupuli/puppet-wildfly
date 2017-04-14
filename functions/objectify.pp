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
