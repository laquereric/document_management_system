# Primer View Components Configuration
# This initializer configures Primer View Components for the Document Management System

# Configure ViewComponent (only if available)
if defined?(ViewComponent)
  # Set up preview paths in the proper Rails way
  Rails.application.config.after_initialize do
    if Rails.application.config.view_component.respond_to?(:preview_paths)
      Rails.application.config.view_component.preview_paths ||= []
      Rails.application.config.view_component.preview_paths << Rails.root.join("app/components/previews")
    end
  end
end

# Configure Primer View Components
if defined?(Primer::ViewComponents)
  Primer::ViewComponents.configure do |config|
    # Use system arguments for consistency
    config.raise_on_invalid_aria = true if config.respond_to?(:raise_on_invalid_aria)
    
    # Enable primer css variables
    config.primer_css_version = "latest" if config.respond_to?(:primer_css_version)
  end
end
