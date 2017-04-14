function wildfly::profile_path(Optional[String] $profile) {
  if $profile and !empty($profile){
    "/profile=${profile}"
  }
}
