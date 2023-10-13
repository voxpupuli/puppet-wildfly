# frozen_string_literal: true

# Managed by modulesync - DO NOT EDIT
# https://voxpupuli.org/docs/updating-files-managed-with-modulesync/

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker(modules: :metadata)

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }

def test_data
  RSpec.configuration.test_data
end

profile = ENV['TEST_profile'] || 'wildfly:9.0.2'

data = {}

case profile

when /(wildfly):(\d{1,}\.\d{1,}\.\d{1,})/
  data['distribution'] = Regexp.last_match(1)
  data['version'] = Regexp.last_match(2)
  data['install_source'] = "http://download.jboss.org/wildfly/#{data['version']}.Final/wildfly-#{data['version']}.Final.tar.gz"
  data['service_name'] = 'wildfly'
when /(jboss-eap):(\d{1,}\.\d{1,})/
  data['distribution'] = Regexp.last_match(1)
  data['version'] = Regexp.last_match(2)
  data['install_source'] = "http://10.0.2.2:9090/jboss-eap-#{data['version']}.tar.gz"
  data['service_name'] = (data['version'].to_f < 7.0 ? 'jboss-as' : 'jboss-eap')
when 'custom'
  data['distribution'] = ENV['TEST_distribution']
  data['version'] = ENV['TEST_version']
  data['install_source'] = ENV['TEST_install_source']
  data['service_name'] = ENV['TEST_service_name']
end

data['java_home'] = '/opt/jdk8u192-b12/'

RSpec.configuration.test_data = data
