# Breadcrumb navigation component

class Navigation::BreadcrumbComponent < ApplicationComponent
  def initialize(breadcrumbs: nil, **system_arguments)
    @breadcrumbs = breadcrumbs || build_breadcrumbs_from_params
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :breadcrumbs, :system_arguments

  def breadcrumb_classes
    "Breadcrumbs py-2"
  end

  # Build breadcrumbs from current controller and action
  def build_breadcrumbs_from_params
    crumbs = [{ label: "Home", path: root_path }]
    
    case controller_name
    when "dashboard"
      crumbs << { label: "Dashboard", path: dashboard_index_path }
    when "documents"
      crumbs << { label: "Documents", path: documents_path }
      if action_name == "show" && params[:id]
        crumbs << { label: "Document Details", path: nil }
      elsif action_name == "new"
        crumbs << { label: "New Document", path: nil }
      end
    when "folders"
      crumbs << { label: "Folders", path: folders_path }
      if action_name == "show" && params[:id]
        crumbs << { label: "Folder Details", path: nil }
      end
    when "teams"
      crumbs << { label: "Teams", path: teams_path }
    when "tags"
      crumbs << { label: "Tags", path: tags_path }
    when "activity_logs"
      crumbs << { label: "Activity", path: activity_logs_path }
    end
    
    crumbs
  end
end
