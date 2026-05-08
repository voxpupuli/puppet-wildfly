# Downloads and installs Wildfly from a remote source or a system package.
class wildfly::install {
  if $wildfly::package_name {
    if $wildfly::dnf_group_install {
      if $wildfly::dnf_group_install_eap_home {
        $install_options = ["EAP_HOME=${wildfly::dnf_group_install_eap_home}"]
      } else {
        $install_options = []
      }
      yum::group { $wildfly::package_name:
        ensure          => 'present',
        timeout         => $wildfly::dnf_group_install_timeout,
        install_options => $install_options,
      }
    } else {
      package { $wildfly::package_name :
        ensure => $wildfly::package_version,
      }
    }
  } else {
    $install_file = "wildfly-${wildfly::version}.Final.tar.gz"
    $install_source = $wildfly::install_source ? {
      undef   => versioncmp($wildfly::version, '25.0.0') ? {
        -1      => "http://download.jboss.org/wildfly/${wildfly::version}.Final/${install_file}",
        default => "https://github.com/wildfly/wildfly/releases/download/${wildfly::version}.Final/${install_file}",
      },
      default => $wildfly::install_source,
    }

    file { $wildfly::install_cache_dir:
      ensure => 'directory',
    }

    file { "${wildfly::install_cache_dir}/${install_file}":
      source => $install_source,
    }

    # Gunzip+Untar wildfly.tar.gz if download was successful.
    ~> exec { "untar ${install_file}":
      command  => "tar --no-same-owner --no-same-permissions --strip-components=1 -C ${wildfly::dirname} -zxvf ${wildfly::install_cache_dir}/${install_file}", # lint:ignore:140chars
      path     => ['/bin', '/usr/bin', '/sbin'],
      loglevel => 'notice',
      creates  => "${wildfly::dirname}/jboss-modules.jar",
      user     => $wildfly::user,
      group    => $wildfly::group,
    }
  }
}
