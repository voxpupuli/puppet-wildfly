require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

require 'coveralls'
require 'simplecov'
require 'simplecov-console'
require 'pry'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_group 'Puppet Types', '/lib/puppet/type/'
  add_group 'Puppet Providers', '/lib/puppet/provider/'
  add_group 'Puppet Extensions', 'lib/puppet_x/'

  add_filter '/spec'
  add_filter 'lib/puppet/parser'
  add_filter 'lib/puppet_x/wildfly/gems/'

  track_files 'lib/**/*.rb'
end

support_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec/support/*.rb'))
Dir[support_path].each { |f| require f }

RSpec.configure do |c|
  c.mock_with :rspec
  c.config = '/doesnotexist'
  c.module_path  = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/modules'))
  c.manifest_dir = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/manifests'))
end

def param_value(subject, type, title, param)
  subject.resource(type, title).send(:parameters)[param.to_sym]
end

at_exit { RSpec::Puppet::Coverage.report! }
