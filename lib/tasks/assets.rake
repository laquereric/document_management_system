namespace :assets do
  desc "Flush all asset caches and remove precompiled assets"
  task flush: :environment do
    puts "🧹 Flushing assets..."

    # Clear asset cache (Propshaft doesn't have cache.clear like Sprockets)
    if defined?(Rails.application.assets)
      puts "Clearing asset cache..."
      if Rails.application.assets.respond_to?(:cache)
        Rails.application.assets.cache.clear
        puts "✓ Asset cache cleared"
      else
        puts "ℹ️  Asset pipeline detected (Propshaft) - no cache to clear"
      end
    end

    # Remove precompiled assets
    public_assets_dir = Rails.root.join("public", "assets")
    if public_assets_dir.exist?
      puts "Removing precompiled assets..."
      FileUtils.rm_rf(public_assets_dir)
      puts "✓ Precompiled assets removed"
    end

    # Clear Sprockets cache if available (for legacy support)
    if defined?(Sprockets)
      if Sprockets.respond_to?(:cache)
        puts "Clearing Sprockets cache..."
        Sprockets.cache.clear
        puts "✓ Sprockets cache cleared"
      end
    end

    # Clear importmap cache if using importmaps
    if defined?(Importmap)
      puts "Clearing importmap cache..."
      Importmap.cache.clear if Importmap.respond_to?(:cache)
      puts "✓ Importmap cache cleared"
    end

    # Clear temporary asset files
    tmp_assets_dir = Rails.root.join("tmp", "assets")
    if tmp_assets_dir.exist?
      puts "Cleaning temporary asset files..."
      FileUtils.rm_rf(tmp_assets_dir)
      puts "✓ Temporary asset files cleaned"
    end

    puts "\n🎨 Asset flush completed successfully!"
    puts "Run 'rails assets:precompile' to rebuild assets if needed."
  end

  desc "Flush assets and precompile them fresh"
  task flush_and_precompile: :environment do
    Rake::Task["assets:flush"].invoke
    puts "\n🔄 Precompiling assets..."
    Rake::Task["assets:precompile"].invoke
    puts "✓ Assets precompiled successfully!"
  end
end
