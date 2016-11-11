#wildfly
[![Build Status](https://travis-ci.org/biemond/biemond-wildfly.svg?branch=master)](https://travis-ci.org/biemond/biemond-wildfly)  [![Coverage Status](https://coveralls.io/repos/biemond/biemond-wildfly/badge.svg?branch=master&service=github)](https://coveralls.io/github/biemond/biemond-wildfly?branch=master)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with wildfly](#setup)
    * [What wildfly affects](#what-wildfly-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Wildfly 9.0.2](#wildfly-902)
    * [Wildfly 8.2.1](#wildfly-821)
    * [JBoss EAP 6.x (with hiera)](#jboss-eap-6x-with-hiera)
    * [Domain Mode](#domain-mode)
    * [Deployment](#deployment)
    * [User management](#user-management)
    * [Module installation](#module-installation)
    * [Datasources](#datasources)
    * [HTTPS/SSL](#httpsssl)
    * [Server reload](#server-reload)
    * [Messaging](#messaging)
    * [Logging](#logging)
    * [Modcluster](#modcluster)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Public classes](#public-classes)
    * [Private classes](#private-classes)
    * [Public defined types](#public-defined-types)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

created by Edwin Biemond email biemond at gmail dot com
[biemond.blogspot.com](http://biemond.blogspot.com)
[Github homepage](https://github.com/biemond/biemond-wildfly)

Install, configures and manages Wildfly.

Should work on every Redhat or Debian family member, tested it with Wildfly 9.0, 8.2, 8.1 & 8.0 and with JBoss EAP (tested on 6.1/6.2/6.3/6.4). Some defines may work only in certain versions.

[Vagrant Fedora 21, Puppet 4.2.1 example](https://github.com/biemond/vagrant-fedora20-puppet) with Wildfly 8.2 and Apache AJP, Postgress db.

[Vagrant CentOS Standalone HA + Gossip Router example](https://github.com/jairojunior/wildfly-ha-tcpgossip-vagrant-puppet) with two nodes, a gossip router and a load balancer (http + mod_cluster).

[Vagrant CentOS 7.2 Domain Mode](https://github.com/jairojunior/wildfly-domain-vagrant-puppet) with two nodes (Domain master and slave) and a load balancer.

[MCollective JBoss Agent Plugin](https://github.com/jairojunior/mcollective-jboss-agent) might be useful if you want to make consistent large scale changes.

##Module Description

The wildfly module can install, configure and manage (using its HTTP API) Wildfly (8/9) and JBoss AS7/EAP6.

##Setup

###What wildfly affects

* Creates a wildfly service and manages its installation (in an unobtrusive way using Wildfly HTTP API meaning that there are no templates for its standalone/domain configurations file)

* Installs requisite libaio and wget packages

###Setup Requirements

This module requires a JVM ( should already be there ).

Acceptance tests works with **puppetlabs/java** in both CentOS and Debian.

##Usage

```puppet
class { 'wildfly': }
```

###Wildfly 9.0.2

```puppet
class { 'wildfly':
  version        => '9.0.2',
  install_source => 'http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz',
}
```

###Wildfly 8.2.1

```puppet
class { 'wildfly':
  version        => '8.2.1',
  install_source => 'http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz',
}
```

##JBoss EAP 6.x (with hiera)

```puppet
include ::wildfly
```

```yaml
wildfly::service_name: jboss-as
wildfly::conf_file: /etc/jboss-as/jboss-as.conf
wildfly::service_file: jboss-as-standalone.sh
wildfly::install_source: http://mywebserver/jboss-eap-6.4.tar.gz
```

## Domain Mode

### Domain Master

```puppet
class { 'wildfly':
  mode        => 'domain',
  host_config => 'host-master.xml'
}

wildfly::config::mgmt_user { 'slave1':
  password => 'wildfly',
}
```

> **NOTE:** Don't forget to set `target_profile` while managing your domain resources.

### Domain Slave

```puppet
class { 'wildfly':
    mode         => 'domain',
    host_config  => 'host-slave.xml',
    domain_slave => {
      host_name             => 'slave1',
      secret                => 'd2lsZGZseQ==', #base64(password)
      domain_master_address => 'DomainBindAddress',
    }
}
```

## Deployment

**From a local or remote source:**

Source supports: http://, ftp://, puppet://, file:

```puppet
wildfly::deployment { 'hawtio.war':
 source => 'http://central.maven.org/maven2/io/hawt/hawtio-web/1.4.48/hawtio-web-1.4.48.war',
}
```

```puppet
wildfly::deployment { 'hawtio.war':
 source => 'puppet:///modules/profile/wildfly/hawtio-web-1.4.48.war',
}
```

```puppet
wildfly::deployment { 'hawtio.war':
 source => 'file:/var/tmp/hawtio-web-1.4.48.war',
}
```

**To a target server-group (domain mode):**

```puppet
wildfly::deployment { 'hawtio.war':
 source       => 'http://central.maven.org/maven2/io/hawt/hawtio-web/1.4.48/hawtio-web-1.4.48.war',
 server_group => 'main-server-group',
}
```


**From nexus:**

> **NOTE:** This feature was removed to avoid 'archive' name collision, but you can still use `archive::nexus` to download an artifact and use as an input for `wildfly::deployment`

## User management

You can add App and Management users (requires server restart).

```puppet
wildfly::config::mgmt_user { 'mgmtuser':
  password => 'mgmtuser'
}
```

```puppet
wildfly::config::app_user { 'appuser':
  password => 'appuser'
}
```

And associate groups or roles to them (requires server restart)

```puppet
wildfly::config::user_groups { 'mgmtuser':
  groups => 'admin,mygroup'
}
```

```puppet
wildfly::config::user_roles { 'appuser':
  roles => 'guest,ejb'
}
```

## Module installation

Install a JAR module from a remote file system, puppet file server or local file system.

```puppet
wildfly::config::module { 'org.postgresql':
  source       => 'http://central.maven.org/maven2/org/postgresql/postgresql/9.3-1103-jdbc4/postgresql-9.3-1103-jdbc4.jar',
  dependencies => ['javax.api', 'javax.transaction.api']
}
```

```puppet
wildfly::config::module { 'org.postgresql':
  source       => 'puppet:///modules/profiles/wildfly/postgresql-9.3-1103-jdbc4.jar',
  dependencies => ['javax.api', 'javax.transaction.api']
}
```

```puppet
wildfly::config::module { 'org.postgresql':
  source       => 'file:/var/tmp/postgresql-9.3-1103-jdbc4.jar',
  dependencies => ['javax.api', 'javax.transaction.api']
}
```

## Datasources

Setup a driver and a datasource (for domain mode you need to set `target_profile` parameter):

```puppet
wildfly::datasources::driver { 'Driver postgresql':
  driver_name                     => 'postgresql',
  driver_module_name              => 'org.postgresql',
  driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource'
}
->
wildfly::datasources::datasource { 'DemoDS':
  config         => {
    'driver-name'    => 'postgresql',
    'connection-url' => 'jdbc:postgresql://localhost/postgres',
    'jndi-name'      => 'java:jboss/datasources/DemoDS',
    'user-name'      => 'postgres',
    'password'       => 'postgres'
  }
}
```

Alternatively, you can install a JDBC driver and module using deployment if your driver is JDBC4 compliant:

```puppet
wildfly::deployment { 'postgresql-9.3-1103-jdbc4.jar':
  source => 'http://central.maven.org/maven2/org/postgresql/postgresql/9.3-1103-jdbc4/postgresql-9.3-1103-jdbc4.jar'
}
->
wildfly::datasources::datasource { 'DemoDS':
  config         => {
    'driver-name'    => 'postgresql-9.3-1103-jdbc4.jar',
    'connection-url' => 'jdbc:postgresql://localhost/postgres',
    'jndi-name'      => 'java:jboss/datasources/DemoDS',
    'user-name'      => 'postgres',
    'password'       => 'postgres'
  }
}
```

A postgresql normal & XA datasource example

```puppet
wildfly::config::module { 'org.postgresql':
  source       => 'http://central.maven.org/maven2/org/postgresql/postgresql/9.3-1103-jdbc4/postgresql-9.3-1103-jdbc4.jar',
  dependencies => ['javax.api', 'javax.transaction.api'],
  require      => Class['wildfly'],
}
->
wildfly::datasources::driver { 'Driver postgresql':
  driver_name                     => 'postgresql',
  driver_module_name              => 'org.postgresql',
  driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource'
}
->
wildfly::datasources::datasource { 'petshop datasource':
  name           => 'petshopDS',
  config         => { 'driver-name'    => 'postgresql',
                      'connection-url' => 'jdbc:postgresql://10.10.10.10/petshop',
                      'jndi-name'      => 'java:jboss/datasources/petshopDS',
                      'user-name'      => 'petshop',
                      'password'       => 'password'
                    }
}
->
wildfly::datasources::xa_datasource { 'petshop xa datasource':
  name            => 'petshopDSXa',
  config          => {  'driver-name'              => 'postgresql',
                        'jndi-name'                => 'java:jboss/datasources/petshopDSXa',
                        'user-name'                => 'petshop',
                        'password'                 => 'password',
                        'xa-datasource-class'      => 'org.postgresql.xa.PGXADataSource',
                        'xa-datasource-properties' => {
                              'url' => {'value' => 'jdbc:postgresql://10.10.10.10/petshop'}
                        },
  }
}
```

Datasource configuration uses a hash with elements that match JBoss-CLI datasource add elements name. More info here: https://docs.jboss.org/author/display/WFLY8/DataSource+configuration

Configure Database Property, only works for normal datasources

```puppet
wildfly::datasources::db_property { 'DemoDbProperty':
 value => 'demovalue',
 database => 'ExampleDS',
}
```

## HTTPS/SSL

### Wildfly 8+

```puppet
wildfly::undertow::https { 'https':
  socket_binding    => 'https',
  keystore_path     => '/vagrant/identitystore.jks',
  keystore_password => 'changeit',
  key_alias         => 'demo',
  key_password      => 'changeit'
}
```

###JBoss AS7/EAP 6

```puppet
wildfly::web::connector { 'https':
  scheme         => 'https',
  protocol       => 'HTTP/1.1',
  socket_binding => 'https',
  enable_lookups => false,
  secure         => true,
}
->
wildfly::web::ssl { 'ssl':
  connector            => 'https',
  protocol             => 'TLSv1,TLSv1.1,TLSv1.2',
  password             => 'changeit',
  key_alias            => 'demo',
  certificate_key_file => '/opt/identitykeystore.jks',
  cipher_suite         => 'TLS_RSA_WITH_AES_128_CBC_SHA,SSL_RSA_WITH_3DES_EDE_CBC_SHA',
}
```

**Sample identity store configuration with `puppetlabs-java_ks`:**

```puppet
java_ks { 'demo:/opt/identitystore.jks':
  ensure      => latest,
  certificate => '/opt/demo.pub.crt',
  private_key => '/opt/demo.private.pem',
  path        => '/usr/java/jdk1.7.0_75/bin/',
  password    => 'changeit',
}
```

## Server Reload

Some configurations like SSL and modcluster requires a server reload (i.e. `server-state = reload-required`), and it can be achieved with the following snippet:

```puppet
## a_resource_that_requires_reload_when_changed {}
~>
widlfly::util::reload { 'Reload if necessary':
  retries => 2,
  wait    => 15,
}
```

Or

```puppet
wildfly::cli { 'Reload if necessary':
  command => 'reload',
  onlyif  => '(result == reload-required) of read-attribute server-state'
}
```

## Messaging

*`full` profiles only*

```puppet
wildfly::messaging::queue { 'DemoQueue':
  durable  => true,
  entries  => ['java:/jms/queue/DemoQueue'],
  selector => "MessageType = 'AddRequest'"
}

wildfly::messaging::topic { 'DemoTopic':
  entries => ['java:/jms/topic/DemoTopic']
}
```

## Logging

```puppet
wildfly::logging::category { 'DemoCategory':
  level               => 'DEBUG',
  use_parent_handlers => false,
  handlers            =>  ['DemoHandler']
}
```

## System Property

```puppet
wildfly::system::property { 'DemoSysProperty':
 value => 'demovalue'
}
```

## Modcluster

*`full` and `ha` profiles only

```puppet
wildfly::modcluster::config { "Modcluster mybalancer":
  balancer             => 'mybalancer',
  load_balancing_group => 'demolb',
  proxy_url            => '/',
  proxy_list           => '127.0.0.1:6666'
}
```

> **NOTE:** For apache/httpd mod_cluster configuration check: https://github.com/puppetlabs/puppetlabs-apache#class-apachemodcluster

##Reference

- [**Public classes**](#public-classes)
    - [Class: wildfly](#class-wildfly)
- [**Private classes**](#private-classes)
    - [Class: wildfly::prepare](#class-wildflyprepare)
    - [Class: wildfly::install](#class-wildflyinstall)
    - [Class: wildfly::setup](#class-wildflysetup)
    - [Class: wildfly::service](#class-wildflyservice)
- [**Public defined types**](#public-defined-types)
    - [Defined type: wildfly::resource](#defined-type-wildflyresource)
    - [Defined type: wildfly::cli](#defined-type-wildflyexec_cli)
    - [Defined type: wildfly::deployment](#defined-type-wildflydeployment)
    - [Defined type: wildfly::config::module](#defined-type-wildflyconfigmodule)
    - [Defined type: wildfly::config::app_user](#defined-type-wildflyconfigapp_user)
    - [Defined type: wildfly::config::mgmt_user](#defined-type-wildflyconfigmgmt_user)
    - [Defined type: wildfly::config::user_groups](#defined-type-wildflyconfiguser_groups)
    - [Defined type: wildfly::config::user_roles](#defined-type-wildflyconfiguser_roles)

### Public classes

#### Class: `wildfly`

Guides the basic setup and installation of Wildfly on your system.

When this class is declared with the default options, Puppet:

- Download and installs Wildfly from a remote source in your system.
- Installs required packages (wget e libaio)
- Configures/starts the Wildfly service.

You can simply declare the default `wildfly` class:

``` puppet
class { 'wildfly': }
```

**Parameters within `wildfly`:**

##### `version`

Sets the Wildfly version managed in order to handle small differences among versions. Default: `9.0.2`

##### `install_source`

Source of Wildfly tarball installer. Default: `http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz`.

##### `java_home`

Sets the `JAVA_HOME` for Wildfly. Default '/usr/java/default'.

##### `manage_user`

Whether this module should manage wildfly user and group. Default `true`.

##### `group`

Group to own `JBOSS_HOME`. If `manage_user` is `true`, this group will be managed. Default `wildfly`.

##### `user`

User to own `JBOSS_HOME`. If `manage_user` is `true`, this group will be managed. Default `wildfly`.

##### `dirname`

`WILDFLY_HOME`. i.e. The directory where your Wildfly will live. Default `/opt/wildfly`.

##### `package_ensure`

Wether this module should manage required packages (wget and liaio). Default `present`.

##### `service_ensure`

Sets Wildfly's service `name`. Default `wildfly`.

##### `service_ensure`

Sets Wildfly's service `ensure`. Default `true`.

##### `service_enable`

Sets Wildfly's service `enable`. Default `true`.

##### `mode`

Sets Wildfly execution mode will run, `standalone` or `domain`. Default `standalone`.

##### `config`

Sets Wildfly configuration file for initialization when you're using `standalone` mode. Default `standalone.xml`.

##### `domain_config`

Sets Wildfly configuration file for initialization when you're using `domain` mode. Default `domain.xml`.

##### `host_config`

Sets Wildfly Host configuration file for initialization when you're using `domain` mode. Default `host.xml`.

##### `console_log`

Configures service log file. Default `/var/log/wildfly/console.log`.

##### `mgmt_bind`

Sets bind address for management interface. Default `0.0.0.0`.

##### `mgmt_http_port`

Sets HTTP port for HTTP management interface. Default `9990`.

##### `mgmt_https_port`

Sets HTTPs port for management interface. Default `9993`.

##### `public_bind`

Sets bind address for public interface. Default `0.0.0.0`.

##### `public_http_port`

Sets HTTP port for public interface. Default `8080`.

##### `public_https_port`

Sets HTTPs port for public interface. Default `8443`.

##### `ajp_port`

Sets AJP port. Default `8009`.

##### `java_xmx`

Sets Java's `-Xmx` parameter. Default `512m`.

##### `java_xms`

Sets Java's `-Xms` parameter. Default `128m`.

##### `java_maxpermsize`

Sets Java's `-XX:MaxPermSize` parameter. Default `256m`.

##### `java_opts`

Sets `JAVA_OPTS`, allowing to override several Java params, like `Xmx`, `Xms` and `MaxPermSize`, e.g. `-Xms64m -Xmx512m -XX:MaxPermSize=256m`. Default `undef`.

##### `users_mgmt`

Hash containing Wildfly's management users to be managed. Default `{ 'wildfly' => {password => 'wildfly'} }`


### Private classes

#### Class: `wildfly::prepare`

Manages Wildfly requirements.

#### Class: `wildfly::install`

Downloads and installs Wildfly from a remote source.

#### Class: `wildfly::setup`

Manages Wildfly configuration required to run in service mode.

#### Class: `wildfly::service`

Manages Wildfly service.

### Public defined types

#### Defined type: `wildfly::resource`

Manages a Wildfly configuration resource: e.g `/subsystem=datasources/data-source=MyDS or /subsystem=datasources/jdbc-driver=postgresql`. Virtually anything in your configuration XML file that can be manipulated using JBoss-CLI could be managed by this defined type. This define is a wrapper for `wildfly_resource` that defaults to your local Wildfly installation.

#### Defined type: `wildfly::cli`

Executes an arbitrary JBoss-CLI command. This define is a wrapper for `wildfly_cli` that defaults to your local Wildfly installation.

#### Defined type: `wildfly::reload`

Performs a system reload when a reload is required `server-state=reload-required`. This define is a wrapper for `wildfly_reload` that defaults to your local Wildfly installation.

#### Defined type: `wildfly::deployment`

Manages a deployment (JAR, EAR, WAR) in Wildfly. This define is a wrapper for `wildfly_deployment` that defaults to your local Wildfly installation.

#### Defined type: `wildfly::config::module`

Manages a module (`$WILDFLY_HOME/modules`).

#### Defined type: `wildfly::config::app_user`

Manages an Application User (`application-users.properties`) for Wildfly.

#### Defined type: `wildfly::config::mgmt_user`

Manages a Management User (`mgmt-users.properties`) for Wildfly.

#### Defined type: `wildfly::config::user_groups`

Manages groups for a Management User (`mgmt-groups.properties`).

#### Defined type: `wildfly::config::user_roles`

Manages roles for an Application User (`application-roles.properties`).

> **NOTE:** Check types tab (https://forge.puppet.com/biemond/wildfly/types) for more information about custom types/providers.

##Limitations

Some of this module public defined types  (`widfly::datasources`, `wildfly::messaging`, `wildfly::undertow`, etc) are built for Wildfly 8.x and may not work with other versions. When there is a proven alternative for a different version, examples might be provided, otherwise you'll need to build your own abstraction using `wildfly_resource` or `wildfly::resource`.

One discussed approach would be to generate defined types based on Wildfly's configuration schemas (`$WILDFLY_HOME/docs/schema`). 

JBoss AS7/EAP 6 support is limited due to the above limitation and to the fact that init scripts are a little different. (*Don't support debian and have only one script for both standalone/domain modes*).

This bug might also be a problem for standalone-full-ha users in JBoss EAP: https://bugzilla.redhat.com/show_bug.cgi?id=1224170

##Development

### Testing

This module uses puppet-lint, rubocop, rspec-puppet, beaker and travis-ci. We hope you use them before submitting your PR.

```shell
gem install bundler --no-rdoc --no-ri
bundle install --without development
gem update --system 2.1.11

bundle exec rake syntax
bundle exec rake lint
bundle exec rubocop

bundle exec rake spec
bundle exec rspec spec/acceptance # default centos-66-x64
BEAKER_set=centos-72-x64 bundle exec rspec spec/acceptance
BEAKER_set=debian-78-x64 bundle exec rspec spec/acceptance
```

### New features

JBoss/Wildfly configuration management is based on three custom types, `wildfly_resource`, `wildfly_cli` and `wildfly_deployment`. And you can do virtually any configuration that is possible through JBoss-CLI or XML configuration using them.

 So, before build your awesome definition to manage a new resource or introduce a new configuration in an existing resource, check `wildfly::*` (`wildfly::deployment`, `wildfly::datasources::*`, `wildfly::undertow::*`, `wildfly::messaging::*`) for guidance.

If you can't figure out how to achieve your configuration, feel free to open an issue.


##Author/Contributors

- Edwin Biemond (biemond at gmail dot com)
- Jairo Junior (junior.jairo1 at gmail dot com)

More: https://github.com/biemond/biemond-wildfly/graphs/contributors
