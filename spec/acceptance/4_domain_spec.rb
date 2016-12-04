require 'spec_helper_acceptance'

describe "Domain mode with #{test_data['distribution']}:#{test_data['version']}" do
  context 'Initial install Wildfly and verification' do
    it 'applies the manifest without error' do
      pp = <<-EOS
          class { 'wildfly':
            distribution   => '#{test_data['distribution']}',
            version        => '#{test_data['version']}',
            install_source => '#{test_data['install_source']}',
            java_home      => '#{test_data['java_home']}',
            mode           => 'domain',
            host_config    => 'host-master.xml',
          }

      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      shell('sleep 15')
    end

    it 'service wildfly' do
      expect(service(test_data['service_name'])).to be_enabled
      expect(service(test_data['service_name'])).to be_running
    end

    it 'runs on port 9990' do
      expect(port(9990)).to be_listening
    end

    it 'protected management page' do
      shell('curl -v localhost:9990/management 2>&1', :acceptable_exit_codes => 0) do |r|
        expect(r.stdout).to include '401 Unauthorized'
      end
    end
  end
end
