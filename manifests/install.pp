#
# wildfly install class
#
class wildfly::install  {

  $install_file = inline_template('<%=File.basename(URI::parse(@install_source).path)%>')

  archive { "/tmp/${install_file}":
    source        => $wildfly::install_source,
    extract       => true,
    extract_path  => $wildfly::dirname,
    creates       => "${wildfly::dirname}/jboss-modules.jar",
    user          => $wildfly::user,
    group         => $wildfly::group,
    extract_flags => '--strip-components=1 -zxf'
  }

}