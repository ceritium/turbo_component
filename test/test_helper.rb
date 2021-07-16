# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  # Load fixtures from test dummy rails app
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixture_path = ActiveSupport::TestCase.fixture_path 
  ActiveSupport::TestCase.fixtures :all
end
