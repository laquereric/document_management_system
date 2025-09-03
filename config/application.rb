require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DocumentManagementSystem
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Load ViewComponent configuration
    config.autoload_paths += %W[#{config.root}/app/components]

    # Fix for Rails 8 frozen array issues - ensure paths are mutable
    if config.autoload_paths.frozen?
      config.autoload_paths = config.autoload_paths.dup
    end
    if config.eager_load_paths.frozen?
      config.eager_load_paths = config.eager_load_paths.dup
    end

    # Enable autosave functionality
    config.autosave = true
    config.autosave_interval = 30.seconds
    config.autosave_backup_count = 5

    # Mount Primer View Components engine
    config.after_initialize do
      if defined?(Primer::ViewComponents::Engine)
        Rails.application.routes.append do
          mount Primer::ViewComponents::Engine => "/rails/view_components"
        end
      end
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end

# Only load Primer in non-test environments to avoid compatibility issues
unless Rails.env.test?
  require "view_component"
  require "primer/view_components"
  Dir.glob(Rails.root.join("../../app/components/primer/**/*")).each do |file|
    require_relative file
  end
end
