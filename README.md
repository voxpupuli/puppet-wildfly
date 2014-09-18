#Wildfly JBoss puppet module
[![Build Status](https://travis-ci.org/biemond/biemond-wildfly.png)](https://travis-ci.org/biemond/biemond-wildfly)

created by Edwin Biemond email biemond at gmail dot com
[biemond.blogspot.com](http://biemond.blogspot.com)
[Github homepage](https://github.com/biemond/biemond-wildfly)

Should work on every Redhat or Debian family member and tested it with Wildfly 8.1.0 & 8.0.0

##Dependency
This module requires a JVM ( should already be there )

## module defaults
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


##Usage

    class { 'wildfly::install':
      version        => '8.1.0',
      install_source => 'http://download.jboss.org/wildfly/8.1.0.Final/wildfly-8.1.0.Final.tar.gz',
      install_file   => 'wildfly-8.1.0.Final.tar.gz',
      java_home      => '/opt/jdk-8',
    }

or for wildfly 8.0.0

    class { 'wildfly::install':
      version        => '8.0.0',
      install_source => 'http://download.jboss.org/wildfly/8.0.0.Final/wildfly-8.0.0.Final.tar.gz',
      install_file   => 'wildfly-8.0.0.Final.tar.gz',
      java_home      => '/opt/jdk-8',
    }

or you can override a paramater

    class { 'wildfly::install':
      version           => '8.1.0',
      install_source    => 'http://download.jboss.org/wildfly/8.1.0.Final/wildfly-8.1.0.Final.tar.gz',
      install_file      => 'wildfly-8.1.0.Final.tar.gz',
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
      users_mgmt        => { 'wildfly' => { username => 'wildfly', password => '2c6368f4996288fcc621c5355d3e39b7'}},
    }

