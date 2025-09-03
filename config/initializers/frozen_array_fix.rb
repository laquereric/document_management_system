# Fix for Rails 8 frozen array issues in test environment
# This initializer handles frozen arrays that cause issues with Zeitwerk and Bootsnap

if Rails.env.test?
  # Fix Zeitwerk frozen array issues
  if defined?(Zeitwerk::Loader)
    Zeitwerk::Loader.class_eval do
      def push_dir(dir)
        if @dirs.nil?
          @dirs = []
        elsif @dirs.frozen?
          @dirs = @dirs.dup
        end
        @dirs << dir
      end
    end
  end

  # Fix Bootsnap frozen array issues
  if defined?(Bootsnap)
    Bootsnap.singleton_class.prepend(Module.new do
      def load_path_cache
        @load_path_cache ||= super.dup
      end
    end)
  end

  # Ensure autoload paths are mutable
  Rails.application.config.after_initialize do
    if Rails.application.config.respond_to?(:autoload_paths) && Rails.application.config.autoload_paths.frozen?
      Rails.application.config.autoload_paths = Rails.application.config.autoload_paths.dup
    end
    if Rails.application.config.respond_to?(:eager_load_paths) && Rails.application.config.eager_load_paths.frozen?
      Rails.application.config.eager_load_paths = Rails.application.config.eager_load_paths.dup
    end
  end
end
