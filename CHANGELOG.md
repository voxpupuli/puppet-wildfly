# History

## 0.3.3
- Beaker unit tests for CentOS 6.6, 7.0 and Debian 7
- fix debian wildlfy configuration file /etc/default/wildfly

## 0.3.2
- More improvements

## 0.3.1
- Code quality improvement and support for onlyif in wildfly_cli

## 0.3.0
- Introducing custom types/providers in replacement of cli-wrapper and jboss-cli.sh. These custom types/providers use HTTP API instead of JBoss-CLI. It maks it 5-10x faster and easier to maintain. More info here: cpitman/puppet-jboss_admin#68
- Using archive in replacement of wget cause it's faster and incredible simple.
- Removing nexus deployment support since cescoffier/puppet-nexus is not in forge and not being active developed, I'll try to work on a PR for archive (some sort of archive::nexus) and have a single define for deployment that accepts multiple formats of deployment.
- Users still can download from Nexus outside deploy and pass file URL as a parameter.

## 0.2.4
- Debian fix so wildfly-init-debian.sh will be used instead of redhat

## 0.2.3
- update readme

## 0.2.2
- Configure wildfly log with console_log parameter
- Deployment option
- User management
- Module installation
- Datasource configuration
- HTTPS/SSL & Identity store
- Modcluster (Only for HA profiles)
- Messaging Queue or Topics

## 0.2.1
- All port & interface sed actions has been replaced by augeas

## 0.2.0
- Major re-factoring by Jairo Junior
- Extracted some resources to new manifests in order to avoid excessive relationships (require, notify, before, after, etc).
- Created new manifests to express new concepts (wildfly user management).
- Removed shell script templates in order to use package script (wildfly/bin/init.d).
- Using only class { 'wildfly' } instead of class { 'wildfly:install' } cause it gives the impression that i am able to instantiate multiple instances*, like tomcat module (https://forge.puppetlabs.com/puppetlabs/tomcat).
- Removing $install_file parameter cause it can be inferred (file_name_from_url.rb).
- The wildfly management user password is declared in plain text and hash is performed internally (password_hash.rb).
- Introduced new dependencies (wget and stdlib)

## 0.1.9
- some exec executed on every puppet run

## 0.1.8
- Added license
- Support for Wildfly 8.2
- Removed the password on the wildfly user

## 0.1.7
- fix for updating user mgmt file

## 0.1.6
- Fix for Debian, Ubuntu