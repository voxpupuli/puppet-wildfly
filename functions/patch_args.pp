function wildfly::patch_args(
  Stdlib::Unixpath $source,
  Boolean $override_all,
  Array $override,
  Array $preserve) {

  $override_param = join($override, ',')
  $preserve_param = join($preserve, ',')

  case [$override_all, empty($override), empty($preserve)] {
    [true, default, default] : { "${source} --override-all" }
    [false, false, false] : { "${source} --override=${override_param} --preserve=${preserve_param}" }
    [false, false, true] : { "${source} --override=${override_param}" }
    [false, true, false] : { "${source} --preserve=${preserve_param}" }
    [false, true, true] : { $source }
  }

}

