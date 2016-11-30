module Puppet::Parser::Functions
  newfunction(:service_config, :type => :rvalue) do |args|
    distribution = args[0]
    version = args[1]
    mode = args[2]
    init_system = args[3]

    config = {}

    case distribution
    when 'wildfly'
      if function_versioncmp([version, '10']) >= 0
        if init_system == 'systemd'
          config['systemd_native'] = true
          config['systemd_template'] = 'wildfly/wildfly.systemd.service.erb'
          config['conf_file'] = '/etc/wildfly/wildfly.conf'
          config['conf_template'] = 'wildfly/wildfly.systemd.conf.erb'
        else
          path = 'docs/contrib/scripts/init.d'
        end
      else
        path = 'bin/init.d'
      end

      unless config['systemd_native']
        config['service_file'] = "#{path}/wildfly-init-#{lookupvar('osfamily').downcase}.sh"

        case lookupvar('osfamily')
        when 'RedHat'
          config['conf_file'] = '/etc/default/wildfly.conf'
        when 'Debian'
          config['conf_file'] = '/etc/default/wildfly'
        end
        config['conf_template'] = 'wildfly/wildfly.sysvinit.conf.erb'
      end

      config['service_name'] = 'wildfly'
    when 'jboss-eap'
      if function_versioncmp([version, '7']) >= 0
        config['service_file'] = 'bin/init.d/jboss-eap-rhel.sh'
        config['conf_file'] = '/etc/default/jboss-eap.conf'
        config['service_name'] = 'jboss-eap'
      else
        config['service_file'] = "bin/init.d/jboss-as-#{mode}.sh"
        config['conf_file'] = '/etc/jboss-as/jboss-as.conf'
        config['service_name'] = 'jboss-as'
      end
      config['conf_template'] = 'wildfly/wildfly.sysvinit.conf.erb'
    end

    if init_system == 'systemd' && config['systemd_template'].nil?
      config['systemd_template'] = 'wildfly/wildfly.sysvinit.service.erb'
    end

    config
  end
end
