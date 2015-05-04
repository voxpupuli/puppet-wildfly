require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'pathname'
# require 'ci/reporter/rake/rspec'
require 'puppet_blacksmith/rake_tasks'
require 'rake'
require 'rspec/core/rake_task'

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc "Run the tests"
RSpec::Core::RakeTask.new(:test) do |t|
  t.rspec_opts = ['--color', '-f d']
  t.pattern = 'spec/classes/*_spec.rb'
end

PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.send("disable_class_inherits_from_params_class")
PuppetLint.configuration.send("disable_variable_scope")
PuppetLint.configuration.send("disable_case_without_default")

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

task :spec => :test

desc "Run syntax, lint, and spec tests."
task :default => [
	:spec_prep,
	:syntax,
	:test,
	:lint,
	:spec_clean
]

begin
  require 'rubocop/rake_task'
  desc 'Run RuboCop on the lib directory'
  Rubocop::RakeTask.new(:rubocop) do |task|
    task.patterns = ['lib/**/*.rb']
    task.fail_on_error = true
  end
rescue LoadError, NameError
end
