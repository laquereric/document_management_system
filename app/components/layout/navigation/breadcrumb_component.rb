# Breadcrumb navigation component

class Layout::Navigation::BreadcrumbComponent < ApplicationComponent
  def initialize(breadcrumbs: nil, **system_arguments)
    @breadcrumbs = breadcrumbs || build_breadcrumbs_from_params
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :breadcrumbs, :system_arguments

  RootPath= '/'
  
  def breadcrumb_classes
    "Breadcrumbs py-2 #{system_arguments[:class]}"
  end

  # Build breadcrumbs from current controller and action
  def build_breadcrumbs_from_params
    crumbs = [{ label: "Home", path: RootPath }]
    
    case @controller_name
    when "dashboard"
      crumbs << { label: "Dashboard", path: dashboard_index_path }
    when "documents"
      crumbs << { label: "Documents", path: models_documents_path }
      if action_name == "show" && params[:id]
        crumbs << { label: "Document Details", path: nil }
      elsif action_name == "new"
        crumbs << { label: "New Document", path: nil }
      end
    when "folders"
      crumbs << { label: "Folders", path: models_folders_path }
      if action_name == "show" && params[:id]
        crumbs << { label: "Folder Details", path: nil }
      end
    when "organizations"
      crumbs << { label: "Organizations", path: models_organizations_path }
    when "teams"
      crumbs << { label: "Teams", path: models_teams_path }
    when "tags"
      crumbs << { label: "Tags", path: models_tags_path }
    when "activities"
      crumbs << { label: "Activity", path: user_activities_path(current_user) }
    end
    
    crumbs
  end

  # Context methods for the template
  def template_context
    {
      breadcrumbs: breadcrumbs,
      breadcrumb_classes: breadcrumb_classes,
      controller_name: @controller_name,
      action_name: action_name,
      params: params,
      current_user: current_user,
      RootPath: RootPath,
      dashboard_index_path: dashboard_index_path,
      documents_path: models_documents_path,
      folders_path: models_folders_path,
      organizations_path: models_organizations_path,
      tags_path: models_tags_path,
      user_activities_path: method(:user_activities_path),
      build_breadcrumbs_from_params: method(:build_breadcrumbs_from_params)
    }
  end
end
