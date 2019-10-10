source "https://rubygems.org"

if ENV.key?('PUPPET_VERSION')
    puppetversion = "~> #{ENV['PUPPET_VERSION']}"
else
    puppetversion = ['>= 3.7.4']
end

gem 'puppet', puppetversion
gem 'puppet-lint', '>=0.3.2'
gem 'puppetlabs_spec_helper', '>=0.2.0'
gem 'rake', '>=0.9.2.2'
gem 'librarian-puppet', '>=1.0.0'
gem 'public_suffix', '<=2.0.5' if RUBY_VERSION >= '2.0.0'
gem 'metadata-json-lint' if RUBY_VERSION >= '2.0.0'

if RUBY_VERSION.to_i < 2.0
  gem 'json_pure', '< 2.0.2'
end
