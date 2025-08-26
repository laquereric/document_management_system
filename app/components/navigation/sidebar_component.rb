# Sidebar navigation component

class Navigation::SidebarComponent < ApplicationComponent
  VARIANT_OPTIONS = %i[default collapsed].freeze

  def initialize(current_user: nil, variant: :default, **system_arguments)
    @current_user = current_user
    @variant = fetch_or_fallback(VARIANT_OPTIONS, variant, :default)
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :current_user, :variant, :system_arguments

  def sidebar_classes
    base_classes = ["SideNav", "height-full", "border-right"]
    base_classes << "SideNav--narrow" if variant == :collapsed
    base_classes << system_arguments[:class] if system_arguments[:class]
    base_classes.join(" ")
  end

  def collapsed?
    variant == :collapsed
  end

  def navigation_items
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
        active: controller_name == "documents"
      },
      {
        label: "Folders",
        icon: "file-directory",
        path: folders_path,
        active: controller_name == "folders"
      },
      {
        label: "Organizations",
        icon: "organization",
        path: organizations_path,
        active: controller_name == "organizations"
      },
      {
        label: "Tags",
        icon: "tag",
        path: tags_path,
        active: controller_name == "tags"
      },
      {
        label: "Activity",
        icon: "pulse",
        path: activity_logs_path,
        active: controller_name == "activity_logs"
      }
    ]
  end

  def admin_navigation_items
    return [] unless current_user&.admin?
    
    [
      {
        label: "Admin Dashboard",
        icon: "gear",
        path: admin_root_path,
        active: controller_name.starts_with?("admin")
      }
    ]
  end
end
