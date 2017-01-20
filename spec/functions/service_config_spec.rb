describe 'service_config' do
  context 'Wildfly 10' do
    let(:distribution) { 'wildfly' }
    let(:version) { '10.0' }

    before(:each) { scope.expects(:lookupvar).at_most_once.with('osfamily').returns('RedHat') }

    it 'using sysvinit' do
      is_expected.to run.with_params(distribution, version, 'standalone', 'sysvinit').and_return('service_name' => 'wildfly', 'conf_file' => '/etc/default/wildfly.conf', 'service_file' => 'docs/contrib/scripts/init.d/wildfly-init-redhat.sh', 'conf_template' => 'wildfly/wildfly.sysvinit.conf.erb')
    end

    it 'using systemd' do
      is_expected.to run.with_params(distribution, version, 'standalone', 'systemd').and_return("systemd_native"=>true, "systemd_template"=>"wildfly/wildfly.systemd.service.erb", "conf_file"=>"/etc/wildfly/wildfly.conf", "conf_template"=>"wildfly/wildfly.systemd.conf.erb", "service_file"=>"/wildfly-init-redhat.sh", "service_name"=>"wildfly")
    end
  end

  context 'Wildfly < 10' do
    let(:distribution) { 'wildfly' }
    let(:version) { '9.0.2' }

    before(:each) { scope.expects(:lookupvar).with('osfamily').returns('RedHat') }

    it 'using sysvinit' do
      is_expected.to run.with_params(distribution, version, 'standalone', 'sysvinit').and_return('service_name' => 'wildfly', 'conf_file' => '/etc/default/wildfly.conf', 'service_file' => 'bin/init.d/wildfly-init-redhat.sh', 'conf_template' => 'wildfly/wildfly.sysvinit.conf.erb')
    end

    it 'using systemd' do
      is_expected.to run.with_params(distribution, version, 'standalone', 'systemd').and_return('service_name' => 'wildfly', 'conf_file' => '/etc/default/wildfly.conf', 'service_file' => 'bin/init.d/wildfly-init-redhat.sh', 'conf_template' => 'wildfly/wildfly.sysvinit.conf.erb', 'systemd_template' => 'wildfly/wildfly.sysvinit.service.erb')
    end
  end

  context 'JBoss EAP 7' do
    let(:distribution) { 'jboss-eap' }
    let(:version) { '7.0' }

    it 'using sysvinit' do
      is_expected.to run.with_params(distribution, version, 'standalone', 'sysvinit').and_return('service_file' => 'bin/init.d/jboss-eap-rhel.sh', 'conf_file' => '/etc/default/jboss-eap.conf', 'service_name' => 'jboss-eap', 'conf_template' => 'wildfly/wildfly.sysvinit.conf.erb')
    end

    it 'using systemd' do
      is_expected.to run.with_params(distribution, version, 'standalone', 'systemd').and_return('service_file' => 'bin/init.d/jboss-eap-rhel.sh', 'conf_file' => '/etc/default/jboss-eap.conf', 'service_name' => 'jboss-eap', 'conf_template' => 'wildfly/wildfly.sysvinit.conf.erb', 'systemd_template' => 'wildfly/wildfly.sysvinit.service.erb')
    end
  end

  context 'JBoss EAP 6' do
    let(:distribution) { 'jboss-eap' }
    let(:version) { '6.4' }

    it 'using sysvinit' do
      is_expected.to run.with_params(distribution, version, 'standalone', 'sysvinit').and_return('service_file' => 'bin/init.d/jboss-as-standalone.sh', 'conf_file' => '/etc/jboss-as/jboss-as.conf', 'service_name' => 'jboss-as', 'conf_template' => 'wildfly/wildfly.sysvinit.conf.erb')
    end

    it 'using systemd' do
      is_expected.to run.with_params(distribution, version, 'standalone', 'systemd').and_return('service_file' => 'bin/init.d/jboss-as-standalone.sh', 'conf_file' => '/etc/jboss-as/jboss-as.conf', 'service_name' => 'jboss-as', 'conf_template' => 'wildfly/wildfly.sysvinit.conf.erb', 'systemd_template' => 'wildfly/wildfly.sysvinit.service.erb')
    end
  end
end
