class Layout::Sidebar::SideNavComponent < ApplicationComponent
  def initialize(
    controller_name: nil,
    current_user: nil,
    **system_arguments
  )
    @controller_name = controller_name
    @current_user = current_user
    @system_arguments = system_arguments.dup
    @system_arguments[:tag] = :nav
    base_classes = ["border-right", "color-bg-default", "height-full", "width-full", "d-flex", "flex-column"]
    base_classes << system_arguments[:classes] if system_arguments[:classes].present?
    
    @system_arguments[:classes] = base_classes.compact.join(" ")
    @system_arguments["aria-label"] = "Site navigation"
  end

  private

  attr_reader :current_user, :controller_name

  def render_navigation_sections
    sections = []
    
    if user_navigation_items.any?
      sections << render_navigation_section("Navigation", user_navigation_items)
    end
    
    if admin_navigation_items.any?
      sections << render_navigation_section("Administration", admin_navigation_items)
    end
    
    # Add proper spacing between sections
    sections_with_spacing = sections.map.with_index do |section, index|
      if index > 0
        content_tag(:div, section, class: "mt-3")
      else
        section
      end
    end
    
    safe_join(sections_with_spacing)
  end

  def render_navigation_section(title, items)
    render(Local::BaseComponent.new(
      tag: :div, 
      classes: "d-flex flex-column width-full",
      style: "flex-direction: column !important;"
    )) do
      safe_join([
        render_section_header(title),
        *items.map { |item| render_navigation_item(item) }
      ])
    end
  end

  def render_section_header(title)
    render(Local::BaseComponent.new(
      tag: :div,
      classes: "px-3 py-2 border-0 width-full"
    )) do
      content_tag(:h6, title, 
        class: "color-fg-muted f6 text-semibold text-uppercase mb-0"
      )
    end
  end

  def render_navigation_item(item)
    render(Local::BaseComponent.new(
      tag: :a,
      href: item[:path],
      classes: class_names(
        "py-2 px-3 d-flex flex-items-center width-full border-0 color-fg-default no-underline",
        "aria-current": item[:active]
      ),
      "aria-current": item[:active] ? "page" : nil,
      style: "display: block !important; width: 100% !important;"
    )) do
      safe_join([
        render(Local::Beta::Octicon.new(
          icon: item[:icon].to_sym,
          mr: 2,
          "aria-hidden": true
        )),
        content_tag(:span, item[:label], class: "f5")
      ])
    end
  end

  def user_navigation_items
    return [] unless current_user
    [
      {
        label: "Dashboard",
        icon: :home,
        path: dashboard_user_path,
        active: controller_name == "user" && controller_name.starts_with?("dashboard")
      },
      {
        label: "Documents",
        icon: :file,
        path: models_documents_path,
        active: controller_name == "documents"
      },
      {
        label: "Folders",
        icon: :database,
        path: models_folders_path,
        active: controller_name == "folders"
      },
      {
        label: "Tags",
        icon: :tag,
        path: models_tags_path,
        active: controller_name == "tags"
      },
      {
        label: "Activity",
        icon: :clock,
        path: models_activities_path,
        active: controller_name == "activities"
      },
      {
        label: "Profile",
        icon: :person,
        path: models_user_path(current_user),
        active: controller_name == "users"
      }
    ]
  end

  def admin_navigation_items
    return [] unless current_user&.admin?
    [
      {
        label: "Dashboard",
        icon: :gear,
        path: dashboard_admin_path,
        active: controller_name.starts_with?("admin")
      },
      {
        label: "Users",
        icon: :person,
        path: models_users_path,
        active: controller_name == "users"
      },
      {
        label: "Teams",
        icon: :person,
        path: models_teams_path,
        active: controller_name == "teams"
      },
      {
        label: "Organizations",
        icon: :home,
        path: models_organizations_path,
        active: controller_name == "organizations"
      },
      {
        label: "Scenarios",
        icon: :check,
        path: models_scenarios_path,
        active: controller_name == "scenarios"
      }
    ]
  end

  def helpers
    Rails.application.routes.url_helpers
  end

  def dashboard_user_path
    helpers.dashboard_user_path
  end

  def dashboard_admin_path
    helpers.dashboard_admin_path
  end

  def models_documents_path
    helpers.models_documents_path
  end

  def models_folders_path
    helpers.models_folders_path
  end

  def models_tags_path
    helpers.models_tags_path
  end

  def models_activities_path
    helpers.models_activities_path
  end

  def models_users_path
    helpers.models_users_path
  end

  def models_teams_path
    helpers.models_teams_path
  end

  def models_organizations_path
    helpers.models_organizations_path
  end

  def models_scenarios_path
    helpers.models_scenarios_path
  end

  def models_user_path(user)
    helpers.models_user_path(user)
  end
end
