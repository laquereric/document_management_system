namespace :autosave do
  desc "Enable autosave functionality"
  task enable: :environment do
    Rails.application.config.autosave = true
    puts "✅ Autosave enabled"
    puts "   Interval: #{Rails.application.config.autosave_interval}"
    puts "   Backup count: #{Rails.application.config.autosave_backup_count}"
    puts "   Debug mode: #{Rails.application.config.autosave_debug}"
  end

  desc "Disable autosave functionality"
  task disable: :environment do
    Rails.application.config.autosave = false
    puts "❌ Autosave disabled"
  end

  desc "Show autosave status and configuration"
  task status: :environment do
    puts "🔍 Autosave Status Report"
    puts "=" * 40
    puts "Enabled: #{Rails.application.config.autosave ? 'Yes' : 'No'}"
    puts "Environment: #{Rails.env}"
    puts "Interval: #{Rails.application.config.autosave_interval}"
    puts "Backup count: #{Rails.application.config.autosave_backup_count}"
    puts "Debug mode: #{Rails.application.config.autosave_debug}"

    if Rails.application.config.autosave
      puts "\n📁 Autosave paths:"
      puts "   - app/"
      puts "   - config/"
      puts "   - db/"
      puts "   - lib/"

      puts "\n🚫 Excluded file types:"
      puts "   - *.log, *.tmp, *.cache, *.pid, *.lock"
    end
  end

  desc "Clear autosave backups"
  task clear_backups: :environment do
    backup_dir = Rails.root.join("tmp", "autosave")
    if backup_dir.exist?
      FileUtils.rm_rf(backup_dir)
      puts "🗑️  Cleared autosave backups from #{backup_dir}"
    else
      puts "ℹ️  No autosave backups found"
    end
  end

  desc "Test autosave functionality"
  task test: :environment do
    puts "🧪 Testing autosave functionality..."

    # Test file creation
    test_file = Rails.root.join("tmp", "autosave_test.txt")
    File.write(test_file, "Test content at #{Time.current}")

    puts "   Created test file: #{test_file}"

    # Wait for autosave interval
    interval = Rails.application.config.autosave_interval
    puts "   Waiting #{interval} seconds for autosave..."
    sleep(interval.to_i)

    # Check if backup was created
    backup_dir = Rails.root.join("tmp", "autosave")
    if backup_dir.exist?
      puts "   ✅ Backup directory created: #{backup_dir}"
    else
      puts "   ⚠️  Backup directory not found"
    end

    # Clean up test file
    File.delete(test_file) if test_file.exist?
    puts "   Cleaned up test file"

    puts "✅ Autosave test completed"
  end
end
