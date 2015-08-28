#wildfly

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with wildfly](#setup)
    * [What wildfly affects](#what-wildfly-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with wildfly](#beginning-with-wildfly)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

[![Build Status](https://travis-ci.org/biemond/biemond-wildfly.png)](https://travis-ci.org/biemond/biemond-wildfly)

created by Edwin Biemond email biemond at gmail dot com
[biemond.blogspot.com](http://biemond.blogspot.com)
[Github homepage](https://github.com/biemond/biemond-wildfly)

Install, configures and manages Wildfly.

Should work on every Redhat or Debian family member, tested it with Wildfly 9.0, 8.2, 8.1 & 8.0

Can also work with JBoss EAP ( tested on 6.1/6.2/6.3), it may change in the future and probably is not supported on Debian

    # hiera example
    wildfly::service_name: jboss-as
    wildfly::conf_file: /etc/jboss-as/jboss-as.conf
    wildfly::service_file: jboss-as-standalone.sh
    wildfly::install_source: http://mywebserver/jboss-eap-6.1.tar.gz


[Vagrant Fedora 20, Puppet 4.2.1 example](https://github.com/biemond/vagrant-fedora20-puppet) with Wildfly 8.2 and Apache AJP, Postgress db

[Vagrant CentOS HA example](https://github.com/jairojunior/wildfly-ha-vagrant-puppet) with two nodes and a load balancer (Apache + modcluster)

##Module Description

The wildfly module can install, configure and manage (using its HTTP API) Wildfly (8/9) and JBoss AS7/EAP6 (with limitations).

##Setup

###What wildfly affects

* Creates a wildfly service and manages its installation (in an unobtrusive way using Wildfly HTTP API meaning that there are no templates for its standalone/domain configurations file)

###Setup Requirements

This module requires a JVM ( should already be there ).

Acceptance tests works with **puppetlabs/java** in both CentOS and Debian.

###Beginning with wildlfy

## Module defaults
- version           8.2.0
- install_source    http://download.jboss.org/wildfly/8.2.0.Final/wildfly-8.2.0.Final.tar.gz
- java_home         /usr/java/jdk1.7.0_75/ (default dir for oracle official rpm)
- manage_user       true
- group             wildfly
- user              wildfly
- dirname           /opt/wildfly
- mode              standalone
- config            standalone.xml
- domain_config     domain.xml
- host_config       host.xml
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


    class { 'wildfly': }

or for wildfly 9.0.0

    class { 'wildfly':
      version        => '9.0.0',
      install_source => 'http://download.jboss.org/wildfly/9.0.0.Final/wildfly-9.0.0.Final.tar.gz',
      java_home      => '/opt/jdk-8',
    }

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

or with java_opts instead of java_xmx, java_xms, java_maxpermsize

    class { 'wildfly':
      version           => '8.1.0',
      install_source    => 'http://download.jboss.org/wildfly/8.1.0.Final/wildfly-8.1.0.Final.tar.gz',
      java_home         => '/opt/jdk-8',
      group             => 'wildfly',
      user              => 'wildfly',
      dirname           => '/opt/wildfly',
      mode              => 'standalone',
      config            => 'standalone-full.xml',
      java_opts         => '-Xms64m -Xmx512m -XX:MaxPermSize=256m',
      mgmt_http_port    => '9990',
      mgmt_https_port   => '9993',
      public_http_port  => '8080',
      public_https_port => '8443',
      ajp_port          => '8009',
      users_mgmt        => { 'wildfly' => { username => 'wildfly', password => 'wildfly'}},
    }

## Deploy

**From a source:**

Source supports: http://, ftp://, file://

    wildfly::deploy { 'hawtio.war':
     source   => 'http://central.maven.org/maven2/io/hawt/hawtio-web/1.4.48/hawtio-web-1.4.48.war',
     checksum => '303e8fcb569a0c3d33b7c918801e5789621f6639' #sha1
    }

**From Nexus:**

    wildfly::deploy { 'hawtio.war':
      ensure     => present,
      nexus_url  => 'https://oss.sonatype.org',
      gav        => 'io.hawt:hawtio-web:1.4.36',
      repository => 'releases',
      packaging  => 'war',
    }

**From Nexus to a server-group (domain mode):**

    wildfly::deploy { 'hawtio.war':
      ensure       => present,
      nexus_url    => 'https://oss.sonatype.org',
      gav          => 'io.hawt:hawtio-web:1.4.36',
      repository   => 'releases',
      packaging    => 'war',
      server_group => 'main-server-group',
    }

## User management

You can add App and Management users (requires server restart).

    wildfly::config::add_mgmt_user { 'Adding mgmtuser':
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
      roles    => 'guest,ejb'
    }

## Module installation

Install a JAR module from a remote file system.

    wildfly::config::module { 'org.postgresql':
      source       => 'http://central.maven.org/maven2/org/postgresql/postgresql/9.3-1103-jdbc4/postgresql-9.3-1103-jdbc4.jar',
      dependencies => ['javax.api', 'javax.transaction.api']
    }

## Datasources

Setup a driver and a datasource (for domain mode you need to set target_profile parameter):

    wildfly::datasources::driver { 'Driver postgresql':
      driver_name                     => 'postgresql',
      driver_module_name              => 'org.postgresql',
      driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource'
    }
    ->
    wildfly::datasources::datasource { 'DemoDS':
      config         => {
        'driver-name' => 'postgresql',
        'connection-url' => 'jdbc:postgresql://localhost/postgres',
        'jndi-name' => 'java:jboss/datasources/DemoDS',
        'user-name' => 'postgres',
        'password' => 'postgres'
      }
    }

Alternatively, you can install a JDBC driver and module using deploy if your driver is JDBC4 compliant:

    wildfly::deploy { 'postgresql-9.3-1103-jdbc4.jar':
      source => 'http://central.maven.org/maven2/org/postgresql/postgresql/9.3-1103-jdbc4/postgresql-9.3-1103-jdbc4.jar'
    }
    ->
    wildfly::datasources::datasource { 'DemoDS':
      config         => {
        'driver-name' => 'postgresql-9.3-1103-jdbc4.jar',
        'connection-url' => 'jdbc:postgresql://localhost/postgres',
        'jndi-name' => 'java:jboss/datasources/DemoDS',
        'user-name' => 'postgres',
        'password' => 'postgres'
      }
    }

Datasource configuration uses a hash with elements that match JBoss-CLI datasource add elements name. More info here: https://docs.jboss.org/author/display/WFLY8/DataSource+configuration

## HTTPS/SSL

    wildfly::undertow::https { 'https':
      socket_binding    => 'https',
      keystore_path     => '/vagrant/identitystore.jks',
      keystore_password => 'changeit',
      key_alias         => 'demo',
      key_password      => 'changeit'
    }

**Identity Store sample Configuration:**

    java_ks { 'demo:/opt/identitystore.jks':
      ensure      => latest,
      certificate => '/opt/demo.pub.crt',
      private_key => '/opt/demo.private.pem',
      path        => '/usr/java/jdk1.7.0_75/bin/',
      password    => 'changeit',
    }

## Server Reload

Some configurations like SSL and modcluster requires a server reload, it can be achieved with the following snippet:

    wildfly::util::exec_cli { 'Reload if necessary':
      command => 'reload',
      onlyif  => '(result == reload-required) of read-attribute server-state'
    }

## Messaging (Only for full profiles) (for domain mode you need to set target_profile parameter)

    wildfly::messaging::queue { 'DemoQueue':
      durable => true,
      entries => ['java:/jms/queue/DemoQueue'],
      selector => "MessageType = 'AddRequest'"
    }

    wildfly::messaging::topic { 'DemoTopic':
      entries => ['java:/jms/topic/DemoTopic']
    }

## Modcluster (Only for HA profiles) (for domain mode you need to set target_profile parameter)

    wildfly::modcluster::config { "Modcluster mybalancer":
      balancer => 'mybalancer',
      load_balancing_group => 'demolb',
      proxy_url => '/',
      proxy_list => '127.0.0.1:6666'
    }

##Reference

###Classes

####Public classes

* [wildfly]

####Private classes

* [wildfly::install]
* [wildfly::prepare]
* [wildfly::setup]
* [wildfly::service]

###Resources

* [wildfly::config::add_app_user]
* [wildfly::config::add_mgmt_user]
* [wildfly::config::associate_groups_to_user]
* [wildfly::config::associate_roles_to_user]
* [wildfly::config::module]
* [wildfly::util::resource]
* [wildfly::util::exec_cli]
* [wildfly::util::standalone::*]

Check types tab for more info about custom types/providers.

##Limitations

wildfly definitions (datasources, messaging, undertow, etc) which are intended to enforce good practices, syntax sugar or serve as examples are built for Wildfly 8.x and may not work with other versions. (Check Issue #27 for more details)

JBoss AS7/EAP 6 support is limited due to the above limitation and to the fact that service scripts are a little different. (Don't support debian and have only one script for both standalone/domain modes)
This bug might also be a problem for standalone-full-ha users in JBoss EAP: https://bugzilla.redhat.com/show_bug.cgi?id=1224170

##Development

This module uses puppet-lint, rubocop, rspec, beaker and travis-ci. Try to use them before submit your PR.

    gem install bundler --no-rdoc --no-ri
    bundle install --without development
    gem update --system 2.1.11

    bundle exec rake syntax
    bundle exec rake lint
    bundle exec rubocop

    bundle exec rake spec
    bundle exec rspec spec/acceptance # default centos-66-x64
    BEAKER_set=centos-70-x64 bundle exec rspec spec/acceptance
    BEAKER_set=debian-78-x64 bundle exec rspec spec/acceptance

JBoss/Wildfly management is based on three custom types and you can do virtually any JBoss/Wildfly configuration using them. So, before build your awesome definition to manage a resource (anything in configurations XML's) or deploy an artifact from my_internal_protocol://, check wildfly::deploy or wildfly::datasources namespace for guidance.


*Examples*:

        wildfly_cli { 'Enable ExampleDS'
          command => '/subsystem=datasources/data-source=ExampleDS:enable',
          unless  => '(result == true) of /subsystem=datasources/data-source=ExampleDS:read-attribute(name=enabled)'
        }

        wildfly_resource { '/subsystem=datasources/data-source=ExampleDS':
          state => {
                   'driver-name' => 'postgresql',
                   'connection-url' => 'jdbc:postgresql://localhost/example',
                   'jndi-name' => 'java:jboss/datasources/ExampleDS',
                   'user-name' => 'postgres',
                   'password' => 'postgres'
                   }
        }

        wildfly_deploy { 'sample.war':
          source => 'file:/vagrant/sample.war'
        }

    They all require a management username, password, host and port params, as it uses Wildfly HTTP API. *Host defaults to 127.0.0.1 and port to 9990*

##Contributors

The list of contributors can be found at: https://github.com/biemond/biemond-wildfly/graphs/contributors
