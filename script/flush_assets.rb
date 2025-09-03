#!/usr/bin/env ruby
# Script to flush assets in the Document Management System
# Usage: rails runner script/flush_assets.rb

puts "Starting asset cleanup..."

# Load the Rails environment
require_relative '../config/environment'

begin
  puts "🧹 Flushing assets and clearing caches..."

  # Clear asset cache
  if defined?(Rails.application.assets)
    puts "Clearing asset cache..."
    # Propshaft doesn't have a cache.clear method like Sprockets
    if Rails.application.assets.respond_to?(:cache)
      Rails.application.assets.cache.clear
      puts "✓ Asset cache cleared"
    else
      puts "ℹ️  Asset pipeline detected (Propshaft) - no cache to clear"
    end
  else
    puts "⚠️  Asset pipeline not available"
  end

  # Remove precompiled assets
  if defined?(Rails.application.config.assets)
    public_assets_dir = Rails.root.join('public', 'assets')
    if public_assets_dir.exist?
      puts "Removing precompiled assets..."
      FileUtils.rm_rf(public_assets_dir)
      puts "✓ Precompiled assets removed"
    else
      puts "ℹ️  No precompiled assets found"
    end

    # Clear asset manifest
    manifest_file = Rails.root.join('public', 'assets', 'manifest.json')
    if manifest_file.exist?
      File.delete(manifest_file)
      puts "✓ Asset manifest removed"
    end
  end

  # Clear Sprockets cache if available (for legacy support)
  if defined?(Sprockets)
    if Sprockets.respond_to?(:cache)
      puts "Clearing Sprockets cache..."
      Sprockets.cache.clear
      puts "✓ Sprockets cache cleared"
    else
      puts "ℹ️  Sprockets cache not available"
    end
  end

  # Clear importmap cache if using importmaps
  if defined?(Importmap)
    puts "Clearing importmap cache..."
    Importmap.cache.clear if Importmap.respond_to?(:cache)
    puts "✓ Importmap cache cleared"
  end

  # Clear any temporary asset files
  tmp_assets_dir = Rails.root.join('tmp', 'assets')
  if tmp_assets_dir.exist?
    puts "Cleaning temporary asset files..."
    FileUtils.rm_rf(tmp_assets_dir)
    puts "✓ Temporary asset files cleaned"
  end

  # Clear cache directory
  cache_dir = Rails.root.join('tmp', 'cache')
  if cache_dir.exist?
    puts "Cleaning cache directory..."
    FileUtils.rm_rf(cache_dir)
    puts "✓ Cache directory cleaned"
  end

  # Log the cleanup
  if defined?(Rails.logger)
    Rails.logger.info "Asset cleanup script completed successfully"
  end

  puts "\n🎨 Asset cleanup completed successfully!"
  puts "All asset caches, precompiled assets, and temporary files have been flushed."
  puts "\n💡 Tip: You may want to run 'rails assets:precompile' to rebuild assets."

rescue => e
  puts "❌ Error during asset cleanup: #{e.message}"
  puts e.backtrace.first(5).join("\n")
  exit 1
end
