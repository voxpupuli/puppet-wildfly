# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::resource' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:title) { '/subsystem=web' }

      context 'with defaults' do
        let(:pre_condition) { 'include wildfly' }

        it do
          is_expected.to contain_wildfly_resource(title)
            .with(:username => 'puppet',
                  :host     => '127.0.0.1',
                  :port     => '9990')
            .that_requires('Service[wildfly]')
        end
      end

      context 'with overrided parameters' do
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
          is_expected.to contain_wildfly_resource(title)
            .with(:username => 'admin',
                  :password => 'safepassword',
                  :host     => '192.168.10.10',
                  :port     => '10090')
            .that_requires('Service[wildfly]')
        end
      end
    end
  end
end
