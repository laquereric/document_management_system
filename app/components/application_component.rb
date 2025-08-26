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
end
