# Main layout component that wraps the entire application
# Provides consistent structure with header, sidebar, and main content area

class Ui::LayoutComponent < ApplicationComponent
  SIDEBAR_VARIANTS = %i[default collapsed hidden].freeze
  
  def initialize(
    title:,
    sidebar_variant: :default,
    show_breadcrumbs: true,
    current_user: nil,
    **system_arguments
  )
    @title = title
    @sidebar_variant = fetch_or_fallback(SIDEBAR_VARIANTS, sidebar_variant, :default)
    @show_breadcrumbs = show_breadcrumbs
    @current_user = current_user
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :sidebar_variant, :show_breadcrumbs, :current_user, :system_arguments

  def layout_classes
    base_classes = ["Layout", "Layout--flowRow-until-lg"]
    base_classes << "Layout--sidebarPosition-start"
    base_classes.join(" ")
  end

  def sidebar_classes
    base_classes = ["Layout-sidebar", "border-right"]
    case sidebar_variant
    when :collapsed
      base_classes << "Layout-sidebar--narrow"
    when :hidden
      base_classes << "d-none"
    end
    base_classes.join(" ")
  end

  def main_content_classes
    base_classes = ["Layout-main"]
    base_classes << "Layout-main--divided" if sidebar_variant != :hidden
    base_classes.join(" ")
  end

  # Context methods for the template
  def template_context
    {
      layout_classes: layout_classes,
      sidebar_classes: sidebar_classes,
      main_content_classes: main_content_classes,
      title: title,
      sidebar_variant: sidebar_variant,
      show_breadcrumbs: show_breadcrumbs,
      current_user: current_user
    }
  end
end
