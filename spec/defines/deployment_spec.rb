require 'spec_helper'

describe 'wildfly::deployment' do
  let(:facts) do
    { :operatingsystem => 'CentOS',
      :kernel => 'Linux',
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :initsystem => 'systemd',
      :fqdn => 'appserver.localdomain' }
  end

  let(:title) { 'hawtio.war' }

  let(:params) do
    { :source => 'file:///opt/hawtio.war' }
  end

  describe 'with defaults' do
    let(:pre_condition) { 'include wildfly' }

    it do
      is_expected.to contain_wildfly_deployment(title)
        .with(:username => 'puppet',
              :host     => '127.0.0.1',
              :port     => '9990')
        .that_requires(['Service[wildfly]', 'File[/tmp/hawtio.war]'])
    end
  end

  describe 'with overrided parameters' do
    let(:pre_condition) do
      <<-EOS
      class { 'wildfly':
        properties => {
          'jboss.bind.address.management' => '192.168.10.10',
          'jboss.management.http.port' => '10090',
        },
        mgmt_user  => {
          username => 'admin',
          password => 'safepassword',
        }
      }
    EOS
    end

    it do
      is_expected.to contain_wildfly_deployment(title)
        .with(:username => 'admin',
              :password => 'safepassword',
              :host     => '192.168.10.10',
              :port     => '10090')
        .that_requires(['Service[wildfly]', 'File[/tmp/hawtio.war]'])
    end
  end

  describe 'with local file' do
    let(:params) do
      { :source => 'file:///opt/hawtio.war' }
    end

    let(:pre_condition) { 'include wildfly' }

    it { is_expected.to contain_wildfly_deployment(title).that_requires('Service[wildfly]') }
    it { is_expected.to contain_file('/tmp/hawtio.war').with(:owner => 'wildfly', :group => 'wildfly', :mode => '0655', :source => params[:source]) }
  end

  describe 'with remote file' do
    let(:params) do
      { :source => 'http://hawt.io/hawtio.war' }
    end

    let(:pre_condition) { 'include wildfly' }

    it { is_expected.to contain_wildfly_deployment(title).that_requires('Service[wildfly]') }
    it { is_expected.to contain_exec("download deployable from #{params[:source]}").with(:creates => '/tmp/hawtio.war') }
    it { is_expected.to contain_file('/tmp/hawtio.war').with(:owner => 'wildfly', :group => 'wildfly', :mode => '0655') }
  end
end
