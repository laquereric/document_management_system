# Fix for Rails 8 frozen array issues in test environment
# This initializer handles frozen arrays that cause issues with Zeitwerk and Bootsnap

if Rails.env.test?
  # Fix Zeitwerk frozen array issues
  if defined?(Zeitwerk::Loader)
    Zeitwerk::Loader.class_eval do
      def push_dir(path, namespace: Object)
        unless namespace.is_a?(Module) # Note that Class < Module.
          raise Zeitwerk::Error, "#{namespace.inspect} is not a class or module object, should be"
        end

        unless real_mod_name(namespace)
          raise Zeitwerk::Error, "root namespaces cannot be anonymous"
        end

        abspath = File.expand_path(path)
        if dir?(abspath)
          raise_if_conflicting_directory(abspath)
          if @roots.frozen?
            puts "Zeitwerk::Loader.push_dir: @roots is frozen, duplicating"
            @roots = @roots.dup 
          end
          @roots[abspath] = namespace
        else
          raise Zeitwerk::Error, "the root directory #{abspath} does not exist"
        end
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
