# Transform a profile name to a JBoss-CLI profile path.
#
# @param profile name of the profile (e.g. full, full-ha, ha)
# @return a profile path or an empty path.
function wildfly::profile_path(Optional[String] $profile) {
  if $profile and !empty($profile){
    "/profile=${profile}"
  }
}
