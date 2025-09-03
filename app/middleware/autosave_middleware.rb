# Autosave Middleware
# Automatically saves files and creates backups at specified intervals

class AutosaveMiddleware
  def initialize(app)
    @app = app
    @last_save = Time.current
    @backup_dir = Rails.root.join('tmp', 'autosave')
    setup_backup_directory
  end

  def call(env)
    # Check if autosave is enabled
    return @app.call(env) unless Rails.application.config.autosave

    # Check if it's time to autosave
    if should_autosave?
      perform_autosave
      @last_save = Time.current
    end

    # Continue with the request
    @app.call(env)
  end

  private

  def should_autosave?
    interval = Rails.application.config.autosave_interval
    Time.current - @last_save >= interval
  end

  def perform_autosave
    Rails.logger.info "🔄 Performing autosave at #{Time.current}" if Rails.application.config.autosave_debug
    
    # Create backup of important directories
    backup_important_files
    
    # Clean up old backups
    cleanup_old_backups
  end

  def setup_backup_directory
    FileUtils.mkdir_p(@backup_dir) unless @backup_dir.exist?
  end

  def backup_important_files
    autosave_paths = [
      Rails.root.join('app'),
      Rails.root.join('config'),
      Rails.root.join('db'),
      Rails.root.join('lib')
    ]

    timestamp = Time.current.strftime('%Y%m%d_%H%M%S')
    
    autosave_paths.each do |path|
      next unless path.exist?
      
      backup_path = @backup_dir.join("#{path.basename}_#{timestamp}")
      FileUtils.cp_r(path, backup_path)
      
      if Rails.application.config.autosave_debug
        Rails.logger.info "   📁 Backed up: #{path.basename} → #{backup_path.basename}"
      end
    end
  end

  def cleanup_old_backups
    max_backups = Rails.application.config.autosave_backup_count
    
    # Get all backup directories
    backup_dirs = Dir.glob(@backup_dir.join('*')).select { |f| File.directory?(f) }
    
    # Sort by creation time (oldest first)
    backup_dirs.sort_by! { |dir| File.ctime(dir) }
    
    # Remove old backups if we have too many
    if backup_dirs.length > max_backups
      backups_to_remove = backup_dirs[0...-max_backups]
      
      backups_to_remove.each do |backup|
        FileUtils.rm_rf(backup)
        Rails.logger.info "   🗑️  Removed old backup: #{backup.basename}" if Rails.application.config.autosave_debug
      end
    end
  end
end
