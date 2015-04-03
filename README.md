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

## Module instalation

    Install a module from a remote file system. Sample module package: https://www.dropbox.com/s/q9agidgzt8pxmkk/postgresql-9.3-1102-jdbc4-module.tar.gz?dl=0

    wildfly::config::module { 'org.postgresql':
      file_uri => http://localhost:8080/postgresql-9.3-1102-jdbc4-module.tar.gz
    }

## Datasources

    Setup a driver a datasource:

    wildfly::standalone::datasources::driver { 'Driver postgresql':
      driver_name                     => 'postgresql',
      driver_module_name              => 'org.postgresql',
      driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource'
    }
    ->
    wildfly::standalone::datasources::datasource { 'Demo datasource':
      name           => 'DemoDS',
      config         => {
        'driver-name' => 'postgresql',
        'connection-url' => 'jdbc:postgresql://localhost/postgres',
        'jndi-name' => 'java:jboss/datasources/DemoDS',
        'user-name' => 'postgres',
        'password' => 'postgres'
      }
    }

    Datasource configuration uses a hash with elements that match JBoss-CLI datasource add elements name, i.e.:

    allocation-retry-wait-millis         
    allocation-retry                     
    allow-multiple-users                 
    background-validation-millis         
    background-validation                
    blocking-timeout-wait-millis         
    capacity-decrementer-class           
    capacity-decrementer-properties      
    capacity-incrementer-class           
    capacity-incrementer-properties      
    check-valid-connection-sql           
    connection-listener-class            
    connection-listener-property         
    connection-properties                
    connection-url                       
    datasource-class                     
    driver-class                         
    driver-name                          
    enabled                              
    exception-sorter-class-name          
    exception-sorter-properties          
    flush-strategy                       
    idle-timeout-minutes                 
    initial-pool-size                    
    jndi-name                            
    jta                                  
    max-pool-size                        
    min-pool-size                        
    new-connection-sql                   
    password                             
    pool-prefill                         
    pool-use-strict-min                  
    prepared-statements-cache-size       
    query-timeout                        
    reauth-plugin-class-name             
    reauth-plugin-properties             
    security-domain                      
    set-tx-query-timeout                 
    share-prepared-statements            
    spy                                  
    stale-connection-checker-class-name  
    stale-connection-checker-properties  
    track-statements                     
    transaction-isolation                
    url-delimiter                        
    url-selector-strategy-class-name     
    use-ccm                              
    use-fast-fail                        
    use-java-context                     
    use-try-lock                         
    user-name                            
    valid-connection-checker-class-name  
    valid-connection-checker-properties  
    validate-on-match


    More info here: https://docs.jboss.org/author/display/WFLY8/DataSource+configuration

## Messaging (Only for full profile)

    wildfly::standalone::messaging::queue { 'DemoQueue':
      durable => true,
      entries => ['java:/jms/queue/DemoQueue'],
      selector => "MessageType = 'AddRequest'"
    }

    wildfly::standalone::messaging::topic { 'DemoTopic':
      entries => ['java:/jms/topic/DemoTopic']
    }

## Instructions for Developers

    There are two abstractions built on top of JBoss-CLI:

    (1) wildfly::util::exec_cli which is built on top of exec
    (2) wildfly::util::cli which is built on top of: https://github.com/jairojunior/wildfly-cli-wrapper

    Check wildfly::standalone::datasources::datasource to learn how to use them to build anything that is possible using JBoss-CLI