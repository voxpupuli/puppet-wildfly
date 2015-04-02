# Wildfly JBoss puppet module
[![Build Status](https://travis-ci.org/biemond/biemond-wildfly.png)](https://travis-ci.org/biemond/biemond-wildfly)

created by Edwin Biemond email biemond at gmail dot com
[biemond.blogspot.com](http://biemond.blogspot.com)
[Github homepage](https://github.com/biemond/biemond-wildfly)

Big thanks to Jairo Junior for his contributions

Should work on every Redhat or Debian family member, tested it with Wildfly 8.2, 8.1 & 8.0

## Dependency
This module requires a JVM ( should already be there )

## Module defaults
- version           8.2.0
- install_source    http://download.jboss.org/wildfly/8.2.0.Final/wildfly-8.2.0.Final.tar.gz
- java_home         /usr/java/jdk1.7.0_75/ (default dir for oracle official rpm)
- group             wildfly
- user              wildfly
- dirname           /opt/wildfly
- mode              standalone
- config            standalone-full.xml
- java_xmx          512m
- java_xms          128m
- java_maxpermsize  256m
- mgmt_http_port    9990
- mgmt_https_port   9993
- public_http_port  8080
- public_https_port 8443
- ajp_port          8009
- users_mgmt        user 'wildfly' with wildfly as password


## Usage

    class { 'wildfly': }

or for wildfly 8.1.0

    class { 'wildfly':
      version        => '8.1.0',
      install_source => 'http://download.jboss.org/wildfly/8.1.0.Final/wildfly-8.1.0.Final.tar.gz',
      java_home      => '/opt/jdk-8',
    }

or for wildfly 8.0.0

    class { 'wildfly':
      version        => '8.0.0',
      install_source => 'http://download.jboss.org/wildfly/8.0.0.Final/wildfly-8.0.0.Final.tar.gz',
      java_home      => '/opt/jdk-8',
    }

or you can override a paramater

    class { 'wildfly':
      version           => '8.1.0',
      install_source    => 'http://download.jboss.org/wildfly/8.1.0.Final/wildfly-8.1.0.Final.tar.gz',
      java_home         => '/opt/jdk-8',
      group             => 'wildfly',
      user              => 'wildfly',
      dirname           => '/opt/wildfly',
      mode              => 'standalone',
      config            => 'standalone-full.xml',
      java_xmx          => '512m',
      java_xms          => '256m',
      java_maxpermsize  => '256m',
      mgmt_http_port    => '9990',
      mgmt_https_port   => '9993',
      public_http_port  => '8080',
      public_https_port => '8443',
      ajp_port          => '8009',
      users_mgmt        => { 'wildfly' => { username => 'wildfly', password => 'wildfly'}},
    }

## User management

You can add App and Management users (requires server restart).

    wildfly::config::add_app_user { 'Adding mgmtuser':
      username => 'mgmtuser',
      password => 'mgmtuser'
    }

    wildfly::config::add_app_user { 'Adding appuser':
      username => 'appuser',
      password => 'appuser'
    }

And associate groups or roles to them (requires server restart)

    wildfly::config::associate_groups_to_user { 'Associate groups to mgmtuser':
      username => 'mgmtuser',
      groups   => 'admin,mygroup'
    }

    wildfly::config::associate_roles_to_user { 'Associate roles to app user':
      username => 'appuser',
      roles   => 'guest,ejb'
    }