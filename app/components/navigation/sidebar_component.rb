# Sidebar navigation component

class Navigation::SidebarComponent < ApplicationComponent
  VARIANT_OPTIONS = %i[default collapsed].freeze

  def initialize(controller_name: nil, current_user: nil, variant: :default, **system_arguments)
    @controller_name = controller_name
    @current_user = current_user
    @variant = fetch_or_fallback(VARIANT_OPTIONS, variant, :default)
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :current_user, :variant, :system_arguments



  def navigation_items
    []
  end

  def user_navigation_items
    return [] unless current_user
    [
      {
        label: "Dashboard",
        icon: "home",
        path: dashboard_index_path,
        active: current_page?(dashboard_index_path)
      },
      {
        label: "Documents",
        icon: "file-text",
        path: documents_path,
        active: @controller_name == "documents"
      },
      {
        label: "Folders",
        icon: "file-directory",
        path: folders_path,
        active: @controller_name == "folders"
      },
      {
        label: "Tags",
        icon: "tag",
        path: tags_path,
        active: @controller_name == "tags"
      },
      {
        label: "Activity",
        icon: "pulse",
        path: activity_logs_path,
        active: @controller_name == "activity_logs"
      },
      {
        label: "Profile",
        icon: "person",
        path: edit_user_registration_path,
        active: @controller_name == "devise/registrations"
      }
    ]
  end

  def admin_navigation_items
    return [] unless current_user&.admin?
    [
      {
        label: "Dashboard",
        icon: "gear",
        path: admin_root_path,
        active: @controller_name.starts_with?("admin")
      },
      {
        label: "Organizations",
        icon: "organization",
        path: organizations_path,
        active: @controller_name == "organizations"
      },
      {
        label: "Users",
        icon: "people",
        path: admin_users_path,
        active: @controller_name == "admin/users"
      },
      {
        label: "Teams",
        icon: "group",
        path: admin_teams_path,
        active: @controller_name == "admin/teams"
      },
      {
        label: "Scenarios",
        icon: "list-unordered",
        path: admin_scenario_types_path,
        active: @controller_name == "admin/scenario_types"
      },
      {
        label: "Tags",
        icon: "tag",
        path: admin_tags_path,
        active: @controller_name == "admin/tags"
      }
    ]
  end
end
