# History

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