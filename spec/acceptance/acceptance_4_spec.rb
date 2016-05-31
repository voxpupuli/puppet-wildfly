require 'spec_helper_acceptance'

describe 'Acceptance case four. Standalone mode with Wildfly 9' do

  context 'Install Wildfly 9.0.2 with security and verification' do
    it 'Should apply the manifest without error' do

      pp = <<-EOS

          $java_home = $::osfamily ? {
            'RedHat' => '/etc/alternatives/java_sdk',
            'Debian' => "/usr/lib/jvm/java-7-openjdk-${::architecture}",
            default  => undef
          }

          class { 'java': } ->

          class { 'wildfly':
            version        => '9.0.2',
            install_source => 'http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz',
            java_home      => $java_home,
            users_mgmt     => {
              'wildfly' => { password => '3:E]k[NT<j]R:]j4pjF#c5Uay&(499.-4xBcu&!_' },
            },
          } ->

          wildfly::security::ldap_realm { 'SecurityRealm':
            ldap_url                      => 'ldap://localhost:389',
            ldap_search_dn                => 'uid=appserver,cn=users,ou=services,o=my,c=org',
            ldap_search_credential        => 'password',
            ldap_user_base_dn             => 'cn=users,ou=services,o=my,c=org',
            authorization_group_base_dn   => 'cn=groups,ou=services,o=my,c=org',
            apply_to_management_interface => 'true',
          } ->

          wildfly::security::group_role_mapping { 'ADMINS':
            role => 'Administrator',
          } ->

          wildfly::security::user_role_mapping { 'wildfly':
            role => 'SuperUser'
          } ->

          wildfly::security::domain { 'MySecurityDomain':
            login_modules => {
              'RealmDirectLoginModule' => {
                domain         => 'MySecurityDomain',
                code           => 'RealmDirect',
                flag           => 'required',
                module_options => {
                  realm             => 'SecurityRealm',
                  password-stacking => 'useFirstPass',
                }
              },
            },
          }

      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      shell('sleep 15')
    end

    it 'service wildfly' do
      expect(service 'wildfly').to be_enabled
      expect(service 'wildfly').to be_running
    end

    it 'runs on port 8080' do
      expect(port 8080).to be_listening
    end

    it 'welcome page' do
      shell('curl localhost:8080', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include 'Welcome'
      end
    end

    it 'domain resource' do
      shell('/opt/wildfly/bin/jboss-cli.sh --connect "/subsystem=security/security-domain=MySecurityDomain:read-resource"',
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"outcome" => "success"'
      end
    end

    it 'ldap realm LDAP connection resource' do
      shell('/opt/wildfly/bin/jboss-cli.sh --connect "/core-service=management/ldap-connection=SecurityRealm-LDAPConnection:read-resource"',
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"outcome" => "success"'
      end
    end

    it 'ldap realm authentication resources' do
      shell('/opt/wildfly/bin/jboss-cli.sh --connect "/core-service=management/security-realm=SecurityRealm/authentication=local:read-resource"',
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"outcome" => "success"'
      end
      shell('/opt/wildfly/bin/jboss-cli.sh --connect "/core-service=management/security-realm=SecurityRealm/authentication=ldap:read-resource"',
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"outcome" => "success"'
      end
    end

    it 'ldap realm authorization resource' do
      shell('/opt/wildfly/bin/jboss-cli.sh --connect "/core-service=management/security-realm=SecurityRealm/authorization=ldap:read-resource"',
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"outcome" => "success"'
      end
    end

    it 'role mappings' do
      shell('/opt/wildfly/bin/jboss-cli.sh --connect "/core-service=management/access=authorization/role-mapping=SuperUser:read-resource"',
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"outcome" => "success"'
      end
    end

    it 'realm applied to management interface' do
      shell('/opt/wildfly/bin/jboss-cli.sh --connect "/core-service=management/management-interface=http-interface:read-resource"',
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"security-realm" => "SecurityRealm"'
      end
    end

    it 'RBAC settings applied' do
      shell('/opt/wildfly/bin/jboss-cli.sh --connect "/core-service=management/access=authorization:read-resource"',
            :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '"provider" => "rbac"'
      end
    end

  end

end