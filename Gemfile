# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in turbo_component.gemspec.
gemspec

group :development do
  gem "sqlite3"
  gem "byebug"
  gem "puma"
  # gem 'turbo-rails', '0.6.0'
  gem "turbo-rails", git: "https://github.com/ceritium/turbo-rails", branch: "broadcasts-targets"
end

group :rubocop do
  gem "rubocop", ">= 0.90", require: false
  gem "rubocop-packaging", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
end

# To use a debugger
# gem 'byebug', group: [:development, :test]
