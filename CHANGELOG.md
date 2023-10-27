# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v3.0.0](https://github.com/voxpupuli/puppet-wildfly/tree/v3.0.0) (2023-10-27)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v2.3.2...v3.0.0)

**Implemented enhancements:**

- Puppet unable to manage wildfly behind a secured connection [\#207](https://github.com/voxpupuli/puppet-wildfly/issues/207)
- Initial install fails because /var/cache/wget does not exist. [\#191](https://github.com/voxpupuli/puppet-wildfly/issues/191)

**Closed issues:**

- Replace MaxPermSize with MaxMetaspaceSize in domain.conf template [\#288](https://github.com/voxpupuli/puppet-wildfly/issues/288)
- Add parameters to domain.conf variables PROCESS\_CONTROLLER\_JAVA\_OPTS and HOST\_CONTROLLER\_JAVA\_OPTS [\#287](https://github.com/voxpupuli/puppet-wildfly/issues/287)
- where the log file is stored on Puppet Agent by this module [\#260](https://github.com/voxpupuli/puppet-wildfly/issues/260)
- JBOSS-EAP with \*\*systemctl start jboss-eap\*\*  don't works from another machine just  locally [\#258](https://github.com/voxpupuli/puppet-wildfly/issues/258)
- Error: Could not set 'file' on ensure: No such file or directory @ dir\_s\_mkdir  [\#257](https://github.com/voxpupuli/puppet-wildfly/issues/257)
- Wildfly 8.2.0 creating new jgroup stack [\#245](https://github.com/voxpupuli/puppet-wildfly/issues/245)
- Support for Wildlfy 11 [\#230](https://github.com/voxpupuli/puppet-wildfly/issues/230)

**Merged pull requests:**

- Update Readme code examples and rubocop\_todos [\#301](https://github.com/voxpupuli/puppet-wildfly/pull/301) ([rwaffen](https://github.com/rwaffen))
- disable beaker acceptance testing [\#299](https://github.com/voxpupuli/puppet-wildfly/pull/299) ([rwaffen](https://github.com/rwaffen))
- fix spec tests [\#297](https://github.com/voxpupuli/puppet-wildfly/pull/297) ([rwaffen](https://github.com/rwaffen))
- Drop EoL Operating system support & Drop Puppet 4/5/6 support [\#296](https://github.com/voxpupuli/puppet-wildfly/pull/296) ([rwaffen](https://github.com/rwaffen))
- Fix linter [\#295](https://github.com/voxpupuli/puppet-wildfly/pull/295) ([rwaffen](https://github.com/rwaffen))
- Add parameter to set JAVA\_OPTS option MaxMetaspaceSize - Fix \#288 [\#291](https://github.com/voxpupuli/puppet-wildfly/pull/291) ([EmersonPrado](https://github.com/EmersonPrado))
- Add parameters for \(PROCESS|HOST\)\_CONTROLLER\_JAVA\_OPTS in domain.conf - Fix \#287 [\#290](https://github.com/voxpupuli/puppet-wildfly/pull/290) ([EmersonPrado](https://github.com/EmersonPrado))
- Use rvm and Ruby 2.7 in README test setup section [\#285](https://github.com/voxpupuli/puppet-wildfly/pull/285) ([EmersonPrado](https://github.com/EmersonPrado))
- Update bundle install commands in README test setup section [\#282](https://github.com/voxpupuli/puppet-wildfly/pull/282) ([EmersonPrado](https://github.com/EmersonPrado))
- Code content quality [\#281](https://github.com/voxpupuli/puppet-wildfly/pull/281) ([Joris29](https://github.com/Joris29))
- Remove obsolete java parameter [\#280](https://github.com/voxpupuli/puppet-wildfly/pull/280) ([Joris29](https://github.com/Joris29))
- Allow domain management using wildfly::domain::server\_group and wildfly::host::server\_config [\#270](https://github.com/voxpupuli/puppet-wildfly/pull/270) ([thiagomarinho](https://github.com/thiagomarinho))
- Fix wildfly\_cli.rb property `executed` [\#269](https://github.com/voxpupuli/puppet-wildfly/pull/269) ([thiagomarinho](https://github.com/thiagomarinho))
- add StandardOutput to systemd [\#268](https://github.com/voxpupuli/puppet-wildfly/pull/268) ([bc-bjoern](https://github.com/bc-bjoern))
- Add new `refreshonly` parameter to wildfly\_cli and wrapper [\#267](https://github.com/voxpupuli/puppet-wildfly/pull/267) ([alexjfisher](https://github.com/alexjfisher))
- Setup and use HTTPS/TLS on the Management API [\#223](https://github.com/voxpupuli/puppet-wildfly/pull/223) ([frozen3](https://github.com/frozen3))

## [v2.3.2](https://github.com/voxpupuli/puppet-wildfly/tree/v2.3.2) (2018-08-18)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v2.3.1...v2.3.2)

**Closed issues:**

- Use of hard-coded passwords, MD5, and HTTP [\#250](https://github.com/voxpupuli/puppet-wildfly/issues/250)

**Merged pull requests:**

- add possiblity to not reload service when change conf [\#254](https://github.com/voxpupuli/puppet-wildfly/pull/254) ([bc-bjoern](https://github.com/bc-bjoern))
- Display `parser.failure_reason` when there's a failure. [\#242](https://github.com/voxpupuli/puppet-wildfly/pull/242) ([kwolf-zz](https://github.com/kwolf-zz))
- Allow `$` in treetop parsed strings. [\#241](https://github.com/voxpupuli/puppet-wildfly/pull/241) ([kwolf-zz](https://github.com/kwolf-zz))
- Use ${version} in $install\_source when nothing specified. [\#240](https://github.com/voxpupuli/puppet-wildfly/pull/240) ([kwolf-zz](https://github.com/kwolf-zz))

## [v2.3.1](https://github.com/voxpupuli/puppet-wildfly/tree/v2.3.1) (2018-05-08)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v2.3.0...v2.3.1)

**Merged pull requests:**

- Enabled local file or puppet:// source as a install\_source for the tar.gz file [\#238](https://github.com/voxpupuli/puppet-wildfly/pull/238) ([will-wk-chan](https://github.com/will-wk-chan))

## [v2.3.0](https://github.com/voxpupuli/puppet-wildfly/tree/v2.3.0) (2018-05-06)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v2.2.0...v2.3.0)

**Closed issues:**

- Changes for domain.conf and standalone.conf [\#235](https://github.com/voxpupuli/puppet-wildfly/issues/235)
- Defined Type Wrappers for Resources do not allow non-standard use with hard set parameters [\#224](https://github.com/voxpupuli/puppet-wildfly/issues/224)

## [v2.2.0](https://github.com/voxpupuli/puppet-wildfly/tree/v2.2.0) (2017-12-03)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- Add facts [\#190](https://github.com/voxpupuli/puppet-wildfly/issues/190)

**Fixed bugs:**

- Set a value to undefined? [\#198](https://github.com/voxpupuli/puppet-wildfly/issues/198)

**Closed issues:**

- `title patterns that use procs are not supported` [\#226](https://github.com/voxpupuli/puppet-wildfly/issues/226)
- Help to change values in the jboss configuration [\#218](https://github.com/voxpupuli/puppet-wildfly/issues/218)
- Unit file should not be executable [\#211](https://github.com/voxpupuli/puppet-wildfly/issues/211)
- JBoss cli creating resource adapters through hiera [\#210](https://github.com/voxpupuli/puppet-wildfly/issues/210)
- access authorization role mapping fails write operation [\#208](https://github.com/voxpupuli/puppet-wildfly/issues/208)
- Cannot connect to domain controller with domain mode snippets from README [\#203](https://github.com/voxpupuli/puppet-wildfly/issues/203)
- wildfly::resource - subsystem naming - adding bindings [\#202](https://github.com/voxpupuli/puppet-wildfly/issues/202)
- KeyCloak on Ubuntu 16.04 won't start [\#201](https://github.com/voxpupuli/puppet-wildfly/issues/201)
- systemd and custom\_init does not work as expected on centos 7 [\#200](https://github.com/voxpupuli/puppet-wildfly/issues/200)
- wget cert error [\#193](https://github.com/voxpupuli/puppet-wildfly/issues/193)

**Merged pull requests:**

- Fix 'title patterns that use procs are not supported' [\#227](https://github.com/voxpupuli/puppet-wildfly/pull/227) ([alexjfisher](https://github.com/alexjfisher))
- Create connection\_factory.pp [\#219](https://github.com/voxpupuli/puppet-wildfly/pull/219) ([mtdjr](https://github.com/mtdjr))
- Fix 401 Unauthorized race [\#216](https://github.com/voxpupuli/puppet-wildfly/pull/216) ([alexjfisher](https://github.com/alexjfisher))
- Change unit file permissions [\#212](https://github.com/voxpupuli/puppet-wildfly/pull/212) ([bjwschaap](https://github.com/bjwschaap))
- Don't call `keys` on strings in `deep_intersect` [\#205](https://github.com/voxpupuli/puppet-wildfly/pull/205) ([alexjfisher](https://github.com/alexjfisher))
- Support module source '.' and update ldap\_realm [\#199](https://github.com/voxpupuli/puppet-wildfly/pull/199) ([BobVanB](https://github.com/BobVanB))

## [v2.1.0](https://github.com/voxpupuli/puppet-wildfly/tree/v2.1.0) (2017-05-19)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v2.0.3...v2.1.0)

**Merged pull requests:**

- Add containment for subclasses in main class [\#196](https://github.com/voxpupuli/puppet-wildfly/pull/196) ([gabe-sky](https://github.com/gabe-sky))

## [v2.0.3](https://github.com/voxpupuli/puppet-wildfly/tree/v2.0.3) (2017-05-07)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v2.0.2...v2.0.3)

**Implemented enhancements:**

- Support for Infinispan Server [\#170](https://github.com/voxpupuli/puppet-wildfly/issues/170)

## [v2.0.2](https://github.com/voxpupuli/puppet-wildfly/tree/v2.0.2) (2017-04-17)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v2.0.1...v2.0.2)

**Implemented enhancements:**

- Filter and other properties in the module.xml file [\#187](https://github.com/voxpupuli/puppet-wildfly/issues/187)

**Fixed bugs:**

- wildfly::cli write-attribute error \(global-modules\) [\#188](https://github.com/voxpupuli/puppet-wildfly/issues/188)

## [v2.0.1](https://github.com/voxpupuli/puppet-wildfly/tree/v2.0.1) (2017-04-04)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v.2.0.0...v2.0.1)

**Closed issues:**

- install\_source not downloaded to install\_cache\_dir [\#185](https://github.com/voxpupuli/puppet-wildfly/issues/185)

**Merged pull requests:**

- Add deploy\_cache\_dir parameter as a location to store deployment files [\#186](https://github.com/voxpupuli/puppet-wildfly/pull/186) ([joneste](https://github.com/joneste))

## [v.2.0.0](https://github.com/voxpupuli/puppet-wildfly/tree/v.2.0.0) (2017-03-15)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v2.0.0...v.2.0.0)

## [v2.0.0](https://github.com/voxpupuli/puppet-wildfly/tree/v2.0.0) (2017-03-15)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.2.8...v2.0.0)

**Implemented enhancements:**

- Improve CLI Parser [\#177](https://github.com/voxpupuli/puppet-wildfly/issues/177)

**Closed issues:**

- Get rid of wget [\#183](https://github.com/voxpupuli/puppet-wildfly/issues/183)

## [v1.2.8](https://github.com/voxpupuli/puppet-wildfly/tree/v1.2.8) (2017-03-02)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.2.7...v1.2.8)

**Implemented enhancements:**

- Document with puppet strings [\#175](https://github.com/voxpupuli/puppet-wildfly/issues/175)

**Closed issues:**

- Introduce Puppet 4 features [\#181](https://github.com/voxpupuli/puppet-wildfly/issues/181)

## [v1.2.7](https://github.com/voxpupuli/puppet-wildfly/tree/v1.2.7) (2017-02-19)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v.1.2.7...v1.2.7)

## [v.1.2.7](https://github.com/voxpupuli/puppet-wildfly/tree/v.1.2.7) (2017-02-19)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.2.6...v.1.2.7)

**Merged pull requests:**

- Update documentation with working example of WildFly/Jboss reload [\#182](https://github.com/voxpupuli/puppet-wildfly/pull/182) ([admont](https://github.com/admont))

## [v1.2.6](https://github.com/voxpupuli/puppet-wildfly/tree/v1.2.6) (2017-02-15)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.2.5...v1.2.6)

**Fixed bugs:**

- Resource changed once after every wildfly restart [\#180](https://github.com/voxpupuli/puppet-wildfly/issues/180)
- Cannot create naming context due to naming issues [\#179](https://github.com/voxpupuli/puppet-wildfly/issues/179)

## [v1.2.5](https://github.com/voxpupuli/puppet-wildfly/tree/v1.2.5) (2017-02-06)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.2.4...v1.2.5)

**Fixed bugs:**

- Missing value for service\_file [\#176](https://github.com/voxpupuli/puppet-wildfly/issues/176)

**Closed issues:**

- Error when using wildfly\_resource and EXPRESSION\_VALUE [\#178](https://github.com/voxpupuli/puppet-wildfly/issues/178)

## [v1.2.4](https://github.com/voxpupuli/puppet-wildfly/tree/v1.2.4) (2017-01-20)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.2.3...v1.2.4)

**Fixed bugs:**

- wildfly\_resource can't be used for managing an unmanaged installation with multiple instances [\#172](https://github.com/voxpupuli/puppet-wildfly/issues/172)

## [v1.2.3](https://github.com/voxpupuli/puppet-wildfly/tree/v1.2.3) (2017-01-18)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.2.2...v1.2.3)

**Merged pull requests:**

- Add resources to manage queues and topics in JBoss EAP 7 [\#168](https://github.com/voxpupuli/puppet-wildfly/pull/168) ([thiagomarinho](https://github.com/thiagomarinho))

## [v1.2.2](https://github.com/voxpupuli/puppet-wildfly/tree/v1.2.2) (2017-01-10)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.2.1...v1.2.2)

## [v1.2.1](https://github.com/voxpupuli/puppet-wildfly/tree/v1.2.1) (2017-01-05)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.2.0...v1.2.1)

## [v1.2.0](https://github.com/voxpupuli/puppet-wildfly/tree/v1.2.0) (2017-01-02)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.1.0...v1.2.0)

**Merged pull requests:**

- Add OS package install option [\#165](https://github.com/voxpupuli/puppet-wildfly/pull/165) ([zipkid](https://github.com/zipkid))

## [v1.1.0](https://github.com/voxpupuli/puppet-wildfly/tree/v1.1.0) (2016-12-22)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.0.1...v1.1.0)

**Fixed bugs:**

- Deployment timeout [\#167](https://github.com/voxpupuli/puppet-wildfly/issues/167)
- Bind address both in jboss.properties and command line [\#162](https://github.com/voxpupuli/puppet-wildfly/issues/162)
- Missing WILDFLY\_HOME in /etc/wildfly/wildfly.conf [\#161](https://github.com/voxpupuli/puppet-wildfly/issues/161)

**Closed issues:**

- Idempotence issue ? [\#164](https://github.com/voxpupuli/puppet-wildfly/issues/164)
- Improve hiera support [\#163](https://github.com/voxpupuli/puppet-wildfly/issues/163)

**Merged pull requests:**

- Feature/lib puppet feature [\#166](https://github.com/voxpupuli/puppet-wildfly/pull/166) ([zipkid](https://github.com/zipkid))

## [v1.0.1](https://github.com/voxpupuli/puppet-wildfly/tree/v1.0.1) (2016-12-08)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v1.0.0...v1.0.1)

**Closed issues:**

- Improve metadata.json [\#160](https://github.com/voxpupuli/puppet-wildfly/issues/160)
- Unit test custom types/providers [\#150](https://github.com/voxpupuli/puppet-wildfly/issues/150)

## [v1.0.0](https://github.com/voxpupuli/puppet-wildfly/tree/v1.0.0) (2016-12-04)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.5.7...v1.0.0)

**Implemented enhancements:**

- Generate a jboss.properties [\#154](https://github.com/voxpupuli/puppet-wildfly/issues/154)
- Review docs [\#152](https://github.com/voxpupuli/puppet-wildfly/issues/152)
- Rewrite wildfly\_cli to use jboss-cli.sh [\#151](https://github.com/voxpupuli/puppet-wildfly/issues/151)
- Unify init scripts [\#148](https://github.com/voxpupuli/puppet-wildfly/issues/148)
- Wildfly 10 support [\#125](https://github.com/voxpupuli/puppet-wildfly/issues/125)
- Add support for operation headers [\#113](https://github.com/voxpupuli/puppet-wildfly/issues/113)
- Improve domain support [\#106](https://github.com/voxpupuli/puppet-wildfly/issues/106)

**Fixed bugs:**

- Allow "ignore\_outcome" parameter from def\_send to be configurable for wildfly\_cli and exec\_cli [\#136](https://github.com/voxpupuli/puppet-wildfly/issues/136)
- wildfly\_cli\_assembler.rb's  def assemble\_command\(command\) should split only to two pieces  [\#133](https://github.com/voxpupuli/puppet-wildfly/issues/133)

**Closed issues:**

- Enable AJP [\#158](https://github.com/voxpupuli/puppet-wildfly/issues/158)
- Remove ExampleDS [\#157](https://github.com/voxpupuli/puppet-wildfly/issues/157)
- Fix path inclusion [\#156](https://github.com/voxpupuli/puppet-wildfly/issues/156)
- CLI generate error, possible documentation missing? [\#155](https://github.com/voxpupuli/puppet-wildfly/issues/155)
- Acceptance tests [\#153](https://github.com/voxpupuli/puppet-wildfly/issues/153)
- wildfly::deployment behaving incorrectly on refresh event [\#142](https://github.com/voxpupuli/puppet-wildfly/issues/142)
- Could not evaluate: A JSON text must at least contain two octets! [\#141](https://github.com/voxpupuli/puppet-wildfly/issues/141)
- encoding issue [\#139](https://github.com/voxpupuli/puppet-wildfly/issues/139)
- Run Acceptance Tests in PCCI [\#71](https://github.com/voxpupuli/puppet-wildfly/issues/71)
- Update resources that depend on others fails [\#54](https://github.com/voxpupuli/puppet-wildfly/issues/54)

**Merged pull requests:**

- V1.0.0 [\#159](https://github.com/voxpupuli/puppet-wildfly/pull/159) ([jairojunior](https://github.com/jairojunior))

## [v0.5.7](https://github.com/voxpupuli/puppet-wildfly/tree/v0.5.7) (2016-11-04)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.5.6...v0.5.7)

## [v0.5.6](https://github.com/voxpupuli/puppet-wildfly/tree/v0.5.6) (2016-11-02)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.5.5...v0.5.6)

**Implemented enhancements:**

- Obfuscate sensitive properties [\#147](https://github.com/voxpupuli/puppet-wildfly/issues/147)

## [v0.5.5](https://github.com/voxpupuli/puppet-wildfly/tree/v0.5.5) (2016-11-01)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.5.4...v0.5.5)

**Fixed bugs:**

- wildfly\_resource with recursive=true is not idempotent [\#146](https://github.com/voxpupuli/puppet-wildfly/issues/146)
- Handle resources that have a simplified way to be created [\#130](https://github.com/voxpupuli/puppet-wildfly/issues/130)
- Puppet runs fail with "401 - Unauthorized" [\#129](https://github.com/voxpupuli/puppet-wildfly/issues/129)
- Datasource always change state, if there is a number in it. [\#97](https://github.com/voxpupuli/puppet-wildfly/issues/97)

**Closed issues:**

- Failed on mgmt-users.properties  [\#134](https://github.com/voxpupuli/puppet-wildfly/issues/134)
- when standalone.xml is modified outside of puppet wildfly fails [\#78](https://github.com/voxpupuli/puppet-wildfly/issues/78)
- Split module into wildfly \(install, config & service\) and wildfly\_admin \(management\) [\#27](https://github.com/voxpupuli/puppet-wildfly/issues/27)

## [v0.5.4](https://github.com/voxpupuli/puppet-wildfly/tree/v0.5.4) (2016-10-23)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.5.3...v0.5.4)

**Closed issues:**

- New Release hosted on http not Deployed [\#140](https://github.com/voxpupuli/puppet-wildfly/issues/140)

**Merged pull requests:**

- Workaround for WildFly 10 intermittent HTTP/401 response. [\#145](https://github.com/voxpupuli/puppet-wildfly/pull/145) ([cfrantsen](https://github.com/cfrantsen))
- Change wildfly\_cli should\_execute? condition [\#144](https://github.com/voxpupuli/puppet-wildfly/pull/144) ([poreed](https://github.com/poreed))

## [v0.5.3](https://github.com/voxpupuli/puppet-wildfly/tree/v0.5.3) (2016-06-21)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.5.2...v0.5.3)

**Closed issues:**

- Is there a way to pass a properties file into standalone.sh? [\#128](https://github.com/voxpupuli/puppet-wildfly/issues/128)
- Wildfly::Util::Resource check doesn't work with RHEL/CentOS 6.x [\#121](https://github.com/voxpupuli/puppet-wildfly/issues/121)
- Supports file protocol in wildfly::deployment and wildfly::module [\#107](https://github.com/voxpupuli/puppet-wildfly/issues/107)
- Connection refused after reload is issued via Wildfly::Util::Exec\_cli [\#69](https://github.com/voxpupuli/puppet-wildfly/issues/69)

**Merged pull requests:**

- Another fix for \#97, stringify true/false [\#131](https://github.com/voxpupuli/puppet-wildfly/pull/131) ([cfrantsen](https://github.com/cfrantsen))
- Ruby187 Compat + Template Customizations [\#127](https://github.com/voxpupuli/puppet-wildfly/pull/127) ([mpeter](https://github.com/mpeter))
- Add enable property to SSL listener on Wfly \>= 9 [\#126](https://github.com/voxpupuli/puppet-wildfly/pull/126) ([bjwschaap](https://github.com/bjwschaap))
- New acceptance test for deployments [\#120](https://github.com/voxpupuli/puppet-wildfly/pull/120) ([bjwschaap](https://github.com/bjwschaap))
- Add support for 'empty' module [\#119](https://github.com/voxpupuli/puppet-wildfly/pull/119) ([bjwschaap](https://github.com/bjwschaap))

## [v0.5.2](https://github.com/voxpupuli/puppet-wildfly/tree/v0.5.2) (2016-02-18)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.5.1...v0.5.2)

**Closed issues:**

- Set Exec download timeout parametric [\#116](https://github.com/voxpupuli/puppet-wildfly/issues/116)
- Add `login-module` resource type [\#114](https://github.com/voxpupuli/puppet-wildfly/issues/114)
- Travis build fails [\#111](https://github.com/voxpupuli/puppet-wildfly/issues/111)
- always `state changed` for recursive `wildfly::util::resource` [\#108](https://github.com/voxpupuli/puppet-wildfly/issues/108)
- Management interface does not always use Digest authentication [\#103](https://github.com/voxpupuli/puppet-wildfly/issues/103)
- init.d script for wildfly versions prior to 8.2.0 doesn't recognize variable JBOSS\_OPTS [\#102](https://github.com/voxpupuli/puppet-wildfly/issues/102)
- Centos7 wildfly service fails for the first time [\#101](https://github.com/voxpupuli/puppet-wildfly/issues/101)
- CLI tries to use proxy in PE4 [\#99](https://github.com/voxpupuli/puppet-wildfly/issues/99)
- Support for LDAP Security Domain [\#98](https://github.com/voxpupuli/puppet-wildfly/issues/98)
- wget breaks wildfly::config::module [\#95](https://github.com/voxpupuli/puppet-wildfly/issues/95)

**Merged pull requests:**

- Address \#107, enable file and puppet sources for deployment and module [\#118](https://github.com/voxpupuli/puppet-wildfly/pull/118) ([martinbalint](https://github.com/martinbalint))
- Setting Exec download timeout parametric [\#117](https://github.com/voxpupuli/puppet-wildfly/pull/117) ([blues-man](https://github.com/blues-man))
- Refactoring of the login-module [\#115](https://github.com/voxpupuli/puppet-wildfly/pull/115) ([bjwschaap](https://github.com/bjwschaap))
- More flexible package management: [\#112](https://github.com/voxpupuli/puppet-wildfly/pull/112) ([BobVincentatNCRdotcom](https://github.com/BobVincentatNCRdotcom))
- Proposal for security related resources [\#110](https://github.com/voxpupuli/puppet-wildfly/pull/110) ([bjwschaap](https://github.com/bjwschaap))
- Fix for \#97 and \#108 [\#109](https://github.com/voxpupuli/puppet-wildfly/pull/109) ([bjwschaap](https://github.com/bjwschaap))
- Make tarball installation directory configurable [\#105](https://github.com/voxpupuli/puppet-wildfly/pull/105) ([mpeter](https://github.com/mpeter))
- Detect between Digest and Basic authentication [\#104](https://github.com/voxpupuli/puppet-wildfly/pull/104) ([bjwschaap](https://github.com/bjwschaap))
- Make Net::HTTP ignore proxy in Ruby2 [\#100](https://github.com/voxpupuli/puppet-wildfly/pull/100) ([bjwschaap](https://github.com/bjwschaap))

## [v0.5.1](https://github.com/voxpupuli/puppet-wildfly/tree/v0.5.1) (2015-12-16)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.5...v0.5.1)

**Closed issues:**

- Add parameters for controlling wildfly service [\#92](https://github.com/voxpupuli/puppet-wildfly/issues/92)
- Package ensure 'curl' causes conflicts [\#89](https://github.com/voxpupuli/puppet-wildfly/issues/89)
- Error when WARs take a 'long' time to deploy [\#72](https://github.com/voxpupuli/puppet-wildfly/issues/72)
- Deployment via nexus fails. [\#40](https://github.com/voxpupuli/puppet-wildfly/issues/40)
- Configuring AJP port will not enable AJP [\#8](https://github.com/voxpupuli/puppet-wildfly/issues/8)

**Merged pull requests:**

- Fix module wget [\#96](https://github.com/voxpupuli/puppet-wildfly/pull/96) ([bjwschaap](https://github.com/bjwschaap))
- New resource [\#94](https://github.com/voxpupuli/puppet-wildfly/pull/94) ([ferrancg](https://github.com/ferrancg))
- Custom init parameters [\#93](https://github.com/voxpupuli/puppet-wildfly/pull/93) ([bjwschaap](https://github.com/bjwschaap))

## [v0.5](https://github.com/voxpupuli/puppet-wildfly/tree/v0.5) (2015-12-09)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.4.3...v0.5)

**Closed issues:**

- Package\[faraday\]: Provider gem is not functional on this host [\#86](https://github.com/voxpupuli/puppet-wildfly/issues/86)
- Add support for setting driver-class-name property on datasource driver [\#82](https://github.com/voxpupuli/puppet-wildfly/issues/82)
- Domain mode bypasses setup   [\#68](https://github.com/voxpupuli/puppet-wildfly/issues/68)
- wildfly\_deploy fails when deploying in standalone mode. [\#65](https://github.com/voxpupuli/puppet-wildfly/issues/65)
- Error: Could not run: cannot load such file -- faraday\_middleware [\#58](https://github.com/voxpupuli/puppet-wildfly/issues/58)
- Conflicts on the archive module [\#31](https://github.com/voxpupuli/puppet-wildfly/issues/31)

**Merged pull requests:**

- change package resource for curl to function ensure\_resource  [\#91](https://github.com/voxpupuli/puppet-wildfly/pull/91) ([mmarseglia](https://github.com/mmarseglia))
- Removed Archive, first draft. Also CRLF fixes. [\#88](https://github.com/voxpupuli/puppet-wildfly/pull/88) ([jhazelwo](https://github.com/jhazelwo))
- Fix wildfly::util::resource. [\#85](https://github.com/voxpupuli/puppet-wildfly/pull/85) ([jairojunior](https://github.com/jairojunior))
- Add driver-class-name parameter to wildfly::datasources::driver. [\#83](https://github.com/voxpupuli/puppet-wildfly/pull/83) ([jairojunior](https://github.com/jairojunior))

## [v0.4.3](https://github.com/voxpupuli/puppet-wildfly/tree/v0.4.3) (2015-10-15)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.4.2...v0.4.3)

**Closed issues:**

- Issue creating periodic-rotating-file-handler with Wildly\_resource type [\#43](https://github.com/voxpupuli/puppet-wildfly/issues/43)

**Merged pull requests:**

- Pack of fixes and refactoring [\#80](https://github.com/voxpupuli/puppet-wildfly/pull/80) ([jairojunior](https://github.com/jairojunior))
- \[Has Questions\] Update nondestructively [\#79](https://github.com/voxpupuli/puppet-wildfly/pull/79) ([TronPaul](https://github.com/TronPaul))
- allow setting the uid/gid for the wildfly user and group [\#77](https://github.com/voxpupuli/puppet-wildfly/pull/77) ([smbambling](https://github.com/smbambling))

## [v0.4.2](https://github.com/voxpupuli/puppet-wildfly/tree/v0.4.2) (2015-09-26)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.4.1...v0.4.2)

**Closed issues:**

- support for deploying mysql driver? [\#75](https://github.com/voxpupuli/puppet-wildfly/issues/75)

**Merged pull requests:**

- Update CHANGELOG. [\#76](https://github.com/voxpupuli/puppet-wildfly/pull/76) ([jairojunior](https://github.com/jairojunior))
- Fix issue \#72. [\#74](https://github.com/voxpupuli/puppet-wildfly/pull/74) ([jairojunior](https://github.com/jairojunior))
- Remove singleton and introduce timeout for deploy [\#73](https://github.com/voxpupuli/puppet-wildfly/pull/73) ([jairojunior](https://github.com/jairojunior))

## [v0.4.1](https://github.com/voxpupuli/puppet-wildfly/tree/v0.4.1) (2015-08-19)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.4.0...v0.4.1)

**Merged pull requests:**

- qualify variables to make templates work [\#67](https://github.com/voxpupuli/puppet-wildfly/pull/67) ([ulamela](https://github.com/ulamela))

## [v0.4.0](https://github.com/voxpupuli/puppet-wildfly/tree/v0.4.0) (2015-07-25)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.3.7...v0.4.0)

**Closed issues:**

- Min/Max Pool size modified on every Puppet run adding "" around the values [\#62](https://github.com/voxpupuli/puppet-wildfly/issues/62)

## [v0.3.7](https://github.com/voxpupuli/puppet-wildfly/tree/v0.3.7) (2015-07-22)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.3.6...v0.3.7)

**Closed issues:**

- Deploy in Domain mode [\#56](https://github.com/voxpupuli/puppet-wildfly/issues/56)

**Merged pull requests:**

- Update README.md [\#64](https://github.com/voxpupuli/puppet-wildfly/pull/64) ([jairojunior](https://github.com/jairojunior))
- Fix issue \#62. [\#63](https://github.com/voxpupuli/puppet-wildfly/pull/63) ([jairojunior](https://github.com/jairojunior))
- Private classes shouldn't have params. [\#61](https://github.com/voxpupuli/puppet-wildfly/pull/61) ([jairojunior](https://github.com/jairojunior))
- Module definitions now works for both domain and standalone modes [\#60](https://github.com/voxpupuli/puppet-wildfly/pull/60) ([jairojunior](https://github.com/jairojunior))
- Unified deploy for domain/standalone modes. [\#59](https://github.com/voxpupuli/puppet-wildfly/pull/59) ([jairojunior](https://github.com/jairojunior))
- Working on issue \#56 [\#57](https://github.com/voxpupuli/puppet-wildfly/pull/57) ([jairojunior](https://github.com/jairojunior))
- Acceptance test for Wildfly 9 and README content and format update [\#55](https://github.com/voxpupuli/puppet-wildfly/pull/55) ([jairojunior](https://github.com/jairojunior))

## [v0.3.6](https://github.com/voxpupuli/puppet-wildfly/tree/v0.3.6) (2015-07-08)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.3.5...v0.3.6)

**Closed issues:**

- Support managing resources with slashes in their names [\#46](https://github.com/voxpupuli/puppet-wildfly/issues/46)
- Allow resources to be declared absent using wildfly::util::resource [\#45](https://github.com/voxpupuli/puppet-wildfly/issues/45)
- Modules only install to the system directory [\#44](https://github.com/voxpupuli/puppet-wildfly/issues/44)
- How to remove a datasource resource [\#42](https://github.com/voxpupuli/puppet-wildfly/issues/42)
- Invalid recursive parameter in wildfly resources [\#41](https://github.com/voxpupuli/puppet-wildfly/issues/41)
- "domain" mode [\#36](https://github.com/voxpupuli/puppet-wildfly/issues/36)
- XA Datasource always updates [\#32](https://github.com/voxpupuli/puppet-wildfly/issues/32)

**Merged pull requests:**

- exec\_cli support for conditions with arrays [\#53](https://github.com/voxpupuli/puppet-wildfly/pull/53) ([martinbalint](https://github.com/martinbalint))
- Update definitions optional parameters. [\#52](https://github.com/voxpupuli/puppet-wildfly/pull/52) ([jairojunior](https://github.com/jairojunior))
- Some lint fixes and refactorings. [\#50](https://github.com/voxpupuli/puppet-wildfly/pull/50) ([jairojunior](https://github.com/jairojunior))
- Support installing non-system modules [\#49](https://github.com/voxpupuli/puppet-wildfly/pull/49) ([briehman](https://github.com/briehman))
- Support ensure parameter in resource util [\#48](https://github.com/voxpupuli/puppet-wildfly/pull/48) ([briehman](https://github.com/briehman))
- Support escaped slashes in resource names [\#47](https://github.com/voxpupuli/puppet-wildfly/pull/47) ([briehman](https://github.com/briehman))
- Add domain params to init.pp [\#39](https://github.com/voxpupuli/puppet-wildfly/pull/39) ([jairojunior](https://github.com/jairojunior))
- Several fixes for domain mode. [\#38](https://github.com/voxpupuli/puppet-wildfly/pull/38) ([jairojunior](https://github.com/jairojunior))
- Changes to memory settings \(for example\) aren't applied until a manual restart of the service [\#37](https://github.com/voxpupuli/puppet-wildfly/pull/37) ([tstibbs](https://github.com/tstibbs))

## [v0.3.5](https://github.com/voxpupuli/puppet-wildfly/tree/v0.3.5) (2015-06-14)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.3.4...v0.3.5)

**Closed issues:**

- Set JAVA\_OPTS for Standalone [\#33](https://github.com/voxpupuli/puppet-wildfly/issues/33)
- Support XA Datasources [\#28](https://github.com/voxpupuli/puppet-wildfly/issues/28)

**Merged pull requests:**

- Changes to allow wildfly module to deploy jboss EAP. [\#35](https://github.com/voxpupuli/puppet-wildfly/pull/35) ([tstibbs](https://github.com/tstibbs))
- Java opts [\#34](https://github.com/voxpupuli/puppet-wildfly/pull/34) ([TronPaul](https://github.com/TronPaul))
- Support template variable declarations for puppet 4 [\#30](https://github.com/voxpupuli/puppet-wildfly/pull/30) ([SMUnlimited](https://github.com/SMUnlimited))
- Xa Datasource [\#29](https://github.com/voxpupuli/puppet-wildfly/pull/29) ([TronPaul](https://github.com/TronPaul))

## [v0.3.4](https://github.com/voxpupuli/puppet-wildfly/tree/v0.3.4) (2015-05-25)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.3.3...v0.3.4)

**Merged pull requests:**

- Manage user [\#26](https://github.com/voxpupuli/puppet-wildfly/pull/26) ([TronPaul](https://github.com/TronPaul))
- Add custom type/providers docs. [\#25](https://github.com/voxpupuli/puppet-wildfly/pull/25) ([jairojunior](https://github.com/jairojunior))
- Move code to puppet\_x in order to avoid namespace collision. [\#24](https://github.com/voxpupuli/puppet-wildfly/pull/24) ([jairojunior](https://github.com/jairojunior))
- Improves deploy to support both URL and Nexus sources [\#23](https://github.com/voxpupuli/puppet-wildfly/pull/23) ([jairojunior](https://github.com/jairojunior))

## [v0.3.3](https://github.com/voxpupuli/puppet-wildfly/tree/v0.3.3) (2015-05-05)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.3.2...v0.3.3)

**Merged pull requests:**

- init script expects default config in /etc/default/wildfly [\#22](https://github.com/voxpupuli/puppet-wildfly/pull/22) ([ubbo](https://github.com/ubbo))
- First acceptance test and unit test for classes. [\#21](https://github.com/voxpupuli/puppet-wildfly/pull/21) ([jairojunior](https://github.com/jairojunior))

## [v0.3.2](https://github.com/voxpupuli/puppet-wildfly/tree/v0.3.2) (2015-04-28)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.3.1...v0.3.2)

**Merged pull requests:**

- Coming close to a stable release... [\#20](https://github.com/voxpupuli/puppet-wildfly/pull/20) ([jairojunior](https://github.com/jairojunior))

## [v0.3.1](https://github.com/voxpupuli/puppet-wildfly/tree/v0.3.1) (2015-04-26)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.3.0...v0.3.1)

## [v0.3.0](https://github.com/voxpupuli/puppet-wildfly/tree/v0.3.0) (2015-04-25)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.2.4...v0.3.0)

**Closed issues:**

- osfamily keys have to be a strings? [\#16](https://github.com/voxpupuli/puppet-wildfly/issues/16)

**Merged pull requests:**

- Very excited with this PR... Starting to make real progress with Puppet. [\#18](https://github.com/voxpupuli/puppet-wildfly/pull/18) ([jairojunior](https://github.com/jairojunior))
- Still improving README [\#17](https://github.com/voxpupuli/puppet-wildfly/pull/17) ([jairojunior](https://github.com/jairojunior))

## [v0.2.4](https://github.com/voxpupuli/puppet-wildfly/tree/v0.2.4) (2015-04-13)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.2.3...v0.2.4)

## [v0.2.3](https://github.com/voxpupuli/puppet-wildfly/tree/v0.2.3) (2015-04-13)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.2.2...v0.2.3)

**Merged pull requests:**

- Update README.md [\#15](https://github.com/voxpupuli/puppet-wildfly/pull/15) ([jairojunior](https://github.com/jairojunior))

## [v0.2.2](https://github.com/voxpupuli/puppet-wildfly/tree/v0.2.2) (2015-04-12)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.2.1...v0.2.2)

**Closed issues:**

- config file to listen on all interface \[0.0.0.0\] [\#11](https://github.com/voxpupuli/puppet-wildfly/issues/11)

**Merged pull requests:**

- Adding unless condition to deploy and CLI Wrapper and module installation improvement [\#14](https://github.com/voxpupuli/puppet-wildfly/pull/14) ([jairojunior](https://github.com/jairojunior))
- Make wildfly console log location configurable [\#13](https://github.com/voxpupuli/puppet-wildfly/pull/13) ([cinerama70](https://github.com/cinerama70))
- New features [\#12](https://github.com/voxpupuli/puppet-wildfly/pull/12) ([jairojunior](https://github.com/jairojunior))

## [v0.2.1](https://github.com/voxpupuli/puppet-wildfly/tree/v0.2.1) (2015-03-23)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.2.0...v0.2.1)

**Merged pull requests:**

- Introducing augeas [\#10](https://github.com/voxpupuli/puppet-wildfly/pull/10) ([jairojunior](https://github.com/jairojunior))

## [v0.2.0](https://github.com/voxpupuli/puppet-wildfly/tree/v0.2.0) (2015-03-22)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.1.9...v0.2.0)

**Merged pull requests:**

- Big refactoring with a few breaking changes to start new features develo... [\#9](https://github.com/voxpupuli/puppet-wildfly/pull/9) ([jairojunior](https://github.com/jairojunior))

## [v0.1.9](https://github.com/voxpupuli/puppet-wildfly/tree/v0.1.9) (2015-03-07)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.1.8...v0.1.9)

**Closed issues:**

- Module is one version behind with 8.2.0 released now [\#6](https://github.com/voxpupuli/puppet-wildfly/issues/6)

**Merged pull requests:**

- Changed the exec conditions from onlyif to unless, in the other way I ad... [\#7](https://github.com/voxpupuli/puppet-wildfly/pull/7) ([ricciocri](https://github.com/ricciocri))

## [v0.1.8](https://github.com/voxpupuli/puppet-wildfly/tree/v0.1.8) (2015-01-07)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.1.7...v0.1.8)

**Closed issues:**

- Update of mgmt.properties requires a complete installation of WildFly [\#3](https://github.com/voxpupuli/puppet-wildfly/issues/3)

**Merged pull requests:**

- Add a LICENSE file for increased visibility. [\#5](https://github.com/voxpupuli/puppet-wildfly/pull/5) ([pleia2](https://github.com/pleia2))
- do not set default password for system user [\#4](https://github.com/voxpupuli/puppet-wildfly/pull/4) ([ubbo](https://github.com/ubbo))

## [v0.1.7](https://github.com/voxpupuli/puppet-wildfly/tree/v0.1.7) (2014-09-18)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/v0.1.6...v0.1.7)

## [v0.1.6](https://github.com/voxpupuli/puppet-wildfly/tree/v0.1.6) (2014-08-22)

[Full Changelog](https://github.com/voxpupuli/puppet-wildfly/compare/d945a99b8cbff09094801645a8a0675ca324d5d4...v0.1.6)

**Closed issues:**

- bad default config file name [\#2](https://github.com/voxpupuli/puppet-wildfly/issues/2)

**Merged pull requests:**

- changed package libaio to libaio1 [\#1](https://github.com/voxpupuli/puppet-wildfly/pull/1) ([richtmat](https://github.com/richtmat))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
