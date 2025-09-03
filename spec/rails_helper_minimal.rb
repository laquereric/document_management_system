# Minimal Rails helper for loading models without Primer dependencies
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

# Load Rails environment without problematic gems
begin
  require_relative '../config/application'
  require 'rails/test_help'
rescue LoadError => e
  puts "Could not load Rails environment: #{e.message}"
  exit 1
end

# Configure RSpec
RSpec.configure do |config|
  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Configure test database
  config.before(:suite) do
    # Ensure test database is set up
    begin
      ActiveRecord::Base.connection
    rescue ActiveRecord::NoDatabaseError
      system("bundle exec rails db:create RAILS_ENV=test")
      system("bundle exec rails db:schema:load RAILS_ENV=test")
    end
  end

  # Clean up after each test
  config.after(:each) do
    # Clean up any created records
    DatabaseCleaner.clean_with(:truncation)
  end

  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # Filter lines from Rails gems in backtraces
  config.filter_rails_from_backtrace!
end

# Configure shoulda-matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
