# vim:ft=make:noexpandtab:
.PHONY := setup spec-tests syntax lint lint-fix gems help
.DEFAULT_GOAL := help

unit-tests: syntax lint spec-tests template-check ## Run all unit tests

setup: gems

spec-tests: ## Run puppet-rspec tests
	@echo "Running puppet-rspec tests"
	RUBYOPT="-W0" bundle exec rake spec

syntax: ## Run puppet-syntax tests
	@echo "Running puppet-syntax tests"
	RUBYOPT="-W0" bundle exec rake syntax

lint: ## Run puppet-lint tests
	@echo "Running puppet-lint tests"
	RUBYOPT="-W0" bundle exec rake lint

template-check:
	@echo "Checking template rendering"
	tests/check-template.sh firstrun.sh.epp
	tests/check-template.sh cronjob.sh.epp

lint-fix: ## Autofix linting errors
	RUBYOPT="-W0" bundle exec rake lint_autocorrect

gems: ## Install required gems
	RUBYOPT="-W0" bundle install

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
