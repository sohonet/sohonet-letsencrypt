require 'rspec-puppet/rake_task'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

exclude_paths = [
  "**/pkg/**/*",
  "**/vendor/**/*",
  "**/spec/**/*",
]

PuppetLint.configuration.ignore_paths = exclude_paths
PuppetLint.configuration.fail_on_warnings = true

PuppetLint::RakeTask.new :lint_autocorrect do |config|
  config.ignore_paths = exclude_paths
  config.fix = true
end

PuppetSyntax.exclude_paths = exclude_paths

task :default => [:rspec, :lint, :syntax]
