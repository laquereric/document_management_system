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
