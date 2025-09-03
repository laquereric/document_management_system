# Base component class for the Document Management System
# Inherits from ViewComponent::Base and uses Primer CSS classes

# Base component class for the Document Management System
# Inherits from ViewComponent::Base and integrates with Primer design system

class ApplicationComponent < ViewComponent::Base
  # Include Rails helpers if needed
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper
  
  # Define common system arguments
  DEFAULT_SYSTEM_ARGUMENTS = {
    border: false,
    box_shadow: false
  }.freeze

  private

  def merge_system_arguments(args)
    DEFAULT_SYSTEM_ARGUMENTS.merge(args)
  end
  
  # Helper method to validate and fallback for enum-like values
  def fetch_or_fallback(allowed_values, value, fallback)
    allowed_values.include?(value) ? value : fallback
  end
  
  # Helper method for consistent spacing
  def spacing_classes(size = :medium)
    case size
    when :small then "p-2"
    when :medium then "p-3"
    when :large then "p-4"
    else "p-3"
    end
  end
  
  # Helper method for consistent text sizing
  def text_size_classes(size = :medium)
    case size
    when :small then "f6"
    when :medium then "f4"
    when :large then "f3"
    when :xlarge then "f2"
    else "f4"
    end
  end

  # Comprehensive resource cleanup method
  def flush_resources
    # Flush database connection pool if available
    if defined?(ActiveRecord::Base) && ActiveRecord::Base.connection_pool
      ActiveRecord::Base.connection_pool.flush!
    end
    
    # Flush any cached data
    if defined?(Rails.cache)
      Rails.cache.clear
    end
    
    # Clear any instance variables that might hold large objects
    instance_variables.each do |var|
      instance_variable_set(var, nil)
    end
    
    # Force garbage collection if available
    if GC.respond_to?(:start)
      GC.start
    end
    
    # Log resource cleanup
    if defined?(Rails.logger)
      Rails.logger.info "#{self.class.name} resources flushed"
    end
  end

  # Flush assets specifically
  def flush_assets
    if defined?(Rails.application)
      # Clear asset cache (Propshaft doesn't have cache.clear like Sprockets)
      if defined?(Rails.application.assets)
        if Rails.application.assets.respond_to?(:cache)
          Rails.application.assets.cache.clear
        end
      end
      
      # Clear Sprockets cache if available (for legacy support)
      if defined?(Sprockets)
        Sprockets.cache.clear if Sprockets.respond_to?(:cache)
      end
      
      # Log asset cleanup
      if defined?(Rails.logger)
        Rails.logger.info "#{self.class.name} assets flushed"
      end
    end
  end

  # Flush all resources including assets
  def flush_all_resources
    flush_resources
    flush_assets
  end
end
