require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

RSpec.configure do |c|
  project_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    puppet_module_install(:source => project_root, :module_name => 'wildfly')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--force', '--version', '4.2.0')
      on host, puppet('module','install','puppetlabs-java')
      on host, puppet('module','install','puppet-archive')
      on host, puppet('apply', '-e', %{"exec { 'gem install treetop net-http-digest_auth': path => '/opt/puppetlabs/puppet/bin/' }"})
    end
  end
end
