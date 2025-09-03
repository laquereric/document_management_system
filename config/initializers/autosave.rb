# Autosave Configuration
# This initializer sets up automatic file saving and recovery

Rails.application.config.after_initialize do
  # Enable autosave for all environments
  Rails.application.config.autosave = true

  # Set autosave intervals based on environment
  case Rails.env
  when "development"
    Rails.application.config.autosave_interval = 15.seconds
    Rails.application.config.autosave_backup_count = 10
    Rails.application.config.autosave_debug = true
  when "test"
    Rails.application.config.autosave_interval = 5.seconds
    Rails.application.config.autosave_backup_count = 3
    Rails.application.config.autosave_debug = false
  when "production"
    Rails.application.config.autosave_interval = 60.seconds
    Rails.application.config.autosave_backup_count = 5
    Rails.application.config.autosave_debug = false
  end

  # Configure autosave paths
  autosave_paths = [
    Rails.root.join("app"),
    Rails.root.join("config"),
    Rails.root.join("db"),
    Rails.root.join("lib")
  ]

  # Exclude certain file types from autosave
  autosave_exclusions = [
    "*.log",
    "*.tmp",
    "*.cache",
    "*.pid",
    "*.lock"
  ]

  # Log autosave configuration
  Rails.logger.info "Autosave configured: #{Rails.application.config.autosave}"
  Rails.logger.info "Autosave interval: #{Rails.application.config.autosave_interval}"
  Rails.logger.info "Autosave backup count: #{Rails.application.config.autosave_backup_count}"
  Rails.logger.info "Autosave debug: #{Rails.application.config.autosave_debug}"
end
