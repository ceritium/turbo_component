source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in turbo_component.gemspec.
gemspec

group :development do
  gem "sqlite3"
end

group :rubocop do
  gem "rubocop", ">= 0.90", require: false
  gem "rubocop-packaging", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
end

# To use a debugger
# gem 'byebug', group: [:development, :test]
