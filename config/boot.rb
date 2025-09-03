ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# Disable Bootsnap in test environment to avoid frozen array issues
unless ENV["RAILS_ENV"] == "test"
  require "bootsnap/setup" # Speed up boot time by caching expensive operations.
end
