require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

# hosts.each do |host|
#   # Install Puppet
#   on host, install_puppet
# end

RSpec.configure do |c|
  project_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    puppet_module_install(:source => project_root, :module_name => 'wildfly')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--force', '--version', '4.2.0'), :acceptable_exit_codes => [0, 1]
      on host, puppet('module','install','puppetlabs-java'), { :acceptable_exit_codes => [0, 1] }
    end
  end
end
