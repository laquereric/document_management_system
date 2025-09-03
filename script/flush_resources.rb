#!/usr/bin/env ruby
# Script to flush resources in the Document Management System
# Usage: rails runner script/flush_resources.rb

puts "Starting resource cleanup..."

# Load the Rails environment
require_relative '../config/environment'

begin
  # Flush database connections
  if defined?(ActiveRecord::Base) && ActiveRecord::Base.connection_pool
    puts "Flushing database connection pool..."
    ActiveRecord::Base.connection_pool.flush!
    puts "✓ Database connections flushed"
  end

  # Flush Rails cache
  if defined?(Rails.cache)
    puts "Flushing Rails cache..."
    Rails.cache.clear
    puts "✓ Rails cache flushed"
  end

  # Flush assets and precompiled assets
  if defined?(Rails.application)
    puts "Flushing assets..."
    
    # Clear asset cache (Propshaft doesn't have cache.clear like Sprockets)
    if defined?(Rails.application.assets)
      puts "Clearing asset cache..."
      # Propshaft doesn't have a cache.clear method, so we'll just log this
      puts "ℹ️  Asset pipeline detected (Propshaft)"
    end
    
    # Remove precompiled assets
    if defined?(Rails.application.config.assets)
      public_assets_dir = Rails.root.join('public', 'assets')
      if public_assets_dir.exist?
        puts "Removing precompiled assets..."
        FileUtils.rm_rf(public_assets_dir)
        puts "✓ Precompiled assets removed"
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
      Sprockets.cache.clear if Sprockets.respond_to?(:cache)
      puts "✓ Sprockets cache cleared"
    end
  end

  # Clear any temporary files
  if defined?(Rails.root)
    tmp_dir = Rails.root.join('tmp')
    if tmp_dir.exist?
      puts "Cleaning temporary files..."
      Dir.glob(tmp_dir.join('*')).each do |file|
        next if File.basename(file).to_s == 'restart.txt'
        File.delete(file) if File.file?(file)
      end
      puts "✓ Temporary files cleaned"
    end
  end

  # Force garbage collection
  if GC.respond_to?(:start)
    puts "Running garbage collection..."
    GC.start
    puts "✓ Garbage collection completed"
  end

  # Log the cleanup
  if defined?(Rails.logger)
    Rails.logger.info "Resource cleanup script completed successfully"
  end

  puts "\n🎉 Resource cleanup completed successfully!"
  puts "Database connections, cache, and temporary files have been flushed."

rescue => e
  puts "❌ Error during resource cleanup: #{e.message}"
  puts e.backtrace.first(5).join("\n")
  exit 1
end
