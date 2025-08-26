# Base component class for the Document Management System
# Inherits from Primer::Component to get access to Primer design system

class ApplicationComponent < Primer::Component
  # Include Rails helpers if needed
  include Rails.application.routes.url_helpers
  
  # Define common system arguments
  DEFAULT_SYSTEM_ARGUMENTS = {
    border: false,
    box_shadow: false
  }.freeze

  private

  def merge_system_arguments(args)
    DEFAULT_SYSTEM_ARGUMENTS.merge(args)
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
end
