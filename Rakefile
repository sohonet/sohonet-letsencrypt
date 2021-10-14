require 'rspec-puppet/rake_task'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppetlabs_spec_helper/rake_tasks'

exclude_paths = [
  "**/pkg/**/*",
  "**/vendor/**/*",
  "**/spec/**/*",
]

PuppetLint.configuration.disable_checks = ['autoloader_layout']
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetLint.configuration.fail_on_warnings = true

PuppetLint::RakeTask.new :lint_autocorrect do |config|
  config.ignore_paths = exclude_paths
  config.fix = true
end

PuppetSyntax.exclude_paths = exclude_paths

task :default => [:spec, :lint, :syntax]
