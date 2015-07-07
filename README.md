# Wildfly JBoss puppet module
[![Build Status](https://travis-ci.org/biemond/biemond-wildfly.png)](https://travis-ci.org/biemond/biemond-wildfly)

created by Edwin Biemond email biemond at gmail dot com
[biemond.blogspot.com](http://biemond.blogspot.com)
[Github homepage](https://github.com/biemond/biemond-wildfly)

Big thanks to Jairo Junior for his contributions

Should work on every Redhat or Debian family member, tested it with Wildfly 8.2, 8.1 & 8.0

Can also work JBoss EAP ( tested on 6.1/6.2/6.3), it may change in the future and probably is not supported on Debian

    # hiera example
    wildfly::service::service_name: jboss-as
    wildfly::service::custom_wildfly_conf_file: /etc/jboss-as/jboss-as.conf
    wildfly::params::custom_service_file: jboss-as-standalone.sh
    wildfly::install_source: http://mywebserver/jboss-eap-6.1.tar.gz


[Vagrant fedora example](https://github.com/biemond/vagrant-fedora20-puppet) with wildfly and apache ajp, postgress db

[Vagrant CentOS HA example](https://github.com/jairojunior/wildfly-ha-vagrant-puppet) with two nodes and a load balancer (Apache + mdocluster)

## Dependency
This module requires a JVM ( should already be there )

## Module defaults
- version           8.2.0
- install_source    http://download.jboss.org/wildfly/8.2.0.Final/wildfly-8.2.0.Final.tar.gz
- java_home         /usr/java/jdk1.7.0_75/ (default dir for oracle official rpm)
- manage_user       true
- group             wildfly
- user              wildfly
- dirname           /opt/wildfly
- mode              standalone
- config            standalone-full.xml
- domain_config     domain.xml
- host_config       host-master.xml
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

    wildfly::standalone::deploy { 'hawtio.war':
     source   => 'http://central.maven.org/maven2/io/hawt/hawtio-web/1.4.48/hawtio-web-1.4.48.war',
     checksum => '303e8fcb569a0c3d33b7c918801e5789621f6639' #sha1
    }
    
**From Nexus:**

    wildfly::standalone::deploy { 'hawtio.war':
      ensure     => present,
      nexus_url  => 'https://oss.sonatype.org',
      gav        => 'io.hawt:hawtio-web:1.4.36',
      repository => 'releases',
      packaging  => 'war',
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

Setup a driver and a datasource:

    wildfly::standalone::datasources::driver { 'Driver postgresql':
      driver_name                     => 'postgresql',
      driver_module_name              => 'org.postgresql',
      driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource'
    }
    ->
    wildfly::standalone::datasources::datasource { 'DemoDS':
      config         => {
        'driver-name' => 'postgresql',
        'connection-url' => 'jdbc:postgresql://localhost/postgres',
        'jndi-name' => 'java:jboss/datasources/DemoDS',
        'user-name' => 'postgres',
        'password' => 'postgres'
      }
    }

Alternatively, you can install a JDBC driver and module using deploy if your driver is JDBC4 compliant:

    wildfly::standalone::deploy { 'postgresql-9.3-1103-jdbc4.jar':
      source => 'http://central.maven.org/maven2/org/postgresql/postgresql/9.3-1103-jdbc4/postgresql-9.3-1103-jdbc4.jar'
    }
    ->
    wildfly::standalone::datasources::datasource { 'DemoDS':
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

    wildfly::standalone::undertow::https { 'https':
      socket_binding    => 'https',
      keystore_path     => '/vagrant/identitystore.jks',
      keystore_password => 'changeit',
      key_alias         => 'demo',
      key_password      => 'changeit'
    }

**Identity Store sample Configuration:**

    file { '/opt/demo.pub.crt':
      ensure  => file,
      owner   => 'wildfly',
      group   => 'wildfly',
      content => file('demo/demo.pub.crt'),
      mode    => '0755',
    }
    ->
    file { '/opt/demo.private.pem':
      ensure  => file,
      owner   => 'wildfly',
      group   => 'wildfly',
      content => file('demo/demo.private.pem'),
      mode    => '0755',
    }
    ->
    file { '/opt/identitystore.jks':
      ensure  => file,
      owner   => 'wildfly',
      group   => 'wildfly',
      content => file('demo/identitystore.jks'),
      mode    => '0755',
    }
    ->
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

## Messaging (Only for full profiles)

    wildfly::standalone::messaging::queue { 'DemoQueue':
      durable => true,
      entries => ['java:/jms/queue/DemoQueue'],
      selector => "MessageType = 'AddRequest'"
    }

    wildfly::standalone::messaging::topic { 'DemoTopic':
      entries => ['java:/jms/topic/DemoTopic']
    }

## Modcluster (Only for HA profiles)

    wildfly::standalone::modcluster::config { "Modcluster mybalancer":
      balancer => 'mybalancer',
      load_balancing_group => 'demolb',
      proxy_url => '/',
      proxy_list => '127.0.0.1:6666'
    }

## Instructions for Developers

This module is based on three custom types:

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

You can do virtually any Wildfly configuration using these custom types. Also this modules provides some defines in wildfly::standalone namespace which are built on top of these custom types. They are intended to enforce good practices, syntax sugar or serve as examples.

## Testing

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

#wildfly

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with [Modulename]](#setup)
    * [What [Modulename] affects](#what-[modulename]-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with [Modulename]](#beginning-with-[Modulename])
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

A one-maybe-two sentence summary of what the module does/what problem it solves. This is your 30 second elevator pitch for your module. Consider including OS/Puppet version it works with.       

##Module Description

If applicable, this section should have a brief description of the technology the module integrates with and what that integration enables. This section should answer the questions: "What does this module *do*?" and "Why would I use it?"
    
If your module has a range of functionality (installation, configuration, management, etc.) this is the time to mention it.

##Setup

###What [Modulename] affects

* A list of files, packages, services, or operations that the module will alter, impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form. 

###Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled, etc.), mention it here. 
	
###Beginning with [Modulename]	

The very basic steps needed for a user to get the module up and running. 

If your most recent release breaks compatibility or requires particular steps for upgrading, you may wish to include an additional section here: Upgrading (For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

##Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here. 

##Reference

Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is touching on their system but don't need to mess with things. (We are working on automating this section!)

##Limitations

This is where you list OS compatibility, version compatibility, etc.

##Development

Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

##Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You may also add any additional sections you feel are necessary or important to include here. Please use the `## ` header. 