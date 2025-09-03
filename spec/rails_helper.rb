# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this pattern to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Load support files safely for Rails 8 compatibility
support_files = Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort
support_files.each { |f| require f }

# ViewComponent testing (commented out due to Primer compatibility issues)
# require 'view_component/test_helpers'
# require 'capybara/rspec'

# Database cleaner for test isolation
require 'database_cleaner/active_record'

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # Fix for Rails 8 frozen array issues
  config.before(:suite) do
    # Ensure load paths are not frozen
    $LOAD_PATH.dup.each { |path| $LOAD_PATH << path unless $LOAD_PATH.frozen? }

    # Fix Zeitwerk frozen array issues
    if defined?(Zeitwerk::Loader)
      Zeitwerk::Loader.class_eval do
        def push_dir(dir)
          @dirs = @dirs.dup
          @dirs << dir
        end
      end
    end

    # Fix autoload paths
    if Rails.application.config.respond_to?(:autoload_paths)
      Rails.application.config.autoload_paths = Rails.application.config.autoload_paths.dup
    end
    if Rails.application.config.respond_to?(:eager_load_paths)
      Rails.application.config.eager_load_paths = Rails.application.config.eager_load_paths.dup
    end
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/requests`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # ViewComponent testing configuration (commented out due to Primer compatibility issues)
  # config.include ViewComponent::TestHelpers, type: :component
  # config.include Capybara::RSpecMatchers, type: :component

  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Fix for Primer compatibility issues in test environment
  config.before(:each) do
    # Stub Primer::FormHelper if it's not available
    unless defined?(Primer::FormHelper)
      module Primer
        class FormHelper
          def self.included(base)
            # Empty stub to prevent errors
          end
        end
      end
    end
  end

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
end

# Configure shoulda-matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
