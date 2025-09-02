# Header navigation component following Primer design patterns

class Layout::Navigation::HeaderComponent < ApplicationComponent
  def initialize(current_user: nil, title: nil, **system_arguments)
    @current_user = current_user
    @title = title
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :current_user, :title, :system_arguments

  def header_classes
    "Header Header--full border-bottom color-bg-default px-3 py-2 d-flex flex-items-center #{system_arguments[:class]}"
  end

  def brand_classes
    "Header-item d-flex flex-items-center"
  end

  def nav_classes
    "Header-item d-flex"
  end

  def root_path
    root_path
  end

  def new_user_session_path
    new_user_session_path
  end

  # Context methods for the template
  def template_context
    {
      header_classes: header_classes,
      brand_classes: brand_classes,
      nav_classes: nav_classes,
      root_path: root_path,
      new_user_session_path: new_user_session_path,
      current_user: current_user,
      title: title,
      Rails: Rails,
      root_path_helper: method(:root_path),
      new_user_session_path_helper: method(:new_user_session_path)
    }
  end
end
