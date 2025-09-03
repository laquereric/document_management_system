class Layout::Dashboard::Admin::DashboardComponent < ApplicationComponent
  def initialize(total_users:, total_organizations:, total_documents:, total_folders:, users_by_role:, documents_by_status:, recent_activity:, **system_arguments)
    @total_users = total_users
    @total_organizations = total_organizations
    @total_documents = total_documents
    @total_folders = total_folders
    @users_by_role = users_by_role
    @documents_by_status = documents_by_status
    @recent_activity = recent_activity
    @system_arguments = merge_system_arguments(system_arguments)
  end

  def before_render
    @template_context = {
      dashboard_classes: dashboard_classes,
      statistics_data: statistics_data,
      header_data: header_data,
      users_by_role_data: users_by_role_data,
      documents_by_status_data: documents_by_status_data,
      recent_activity_data: recent_activity_data,
      quick_actions_data: quick_actions_data
    }
  end

  private

  attr_reader :total_users, :total_organizations, :total_documents, :total_folders, :users_by_role, :documents_by_status, :recent_activity, :system_arguments

  def dashboard_classes
    "container-lg px-3 #{system_arguments[:class]}"
  end

  def statistics_data
    [
      {
        title: "Total Users",
        value: total_users,
        icon: "people",
        color: "accent",
        subtitle: "Registered users in the system"
      },
      {
        title: "Organizations",
        value: total_organizations,
        icon: "organization",
        color: "success",
        subtitle: "Active organizations"
      },
      {
        title: "Total Documents",
        value: total_documents,
        icon: "file-text",
        color: "attention",
        subtitle: "Documents across all organizations"
      },
      {
        title: "Total Folders",
        value: total_folders,
        icon: "file-directory",
        color: "done",
        subtitle: "Organized document storage"
      }
    ]
  end

  def header_data
    {
      title: "Admin Dashboard",
      description: "System overview and administrative controls",
      icon: "gear",
      badge: {
        type: "admin",
        text: "Admin Access",
        icon: "shield-check"
      }
    }
  end

  def users_by_role_data
    {
      title: "Users by Role",
      data: users_by_role,
      manage_path: :models_users_path,
      manage_text: "Manage Users",
      empty_state: {
        title: "No user data",
        description: "User role statistics will appear here",
        icon: "people"
      }
    }
  end

  def documents_by_status_data
    {
      title: "Documents by Status",
      data: documents_by_status,
      manage_path: :models_documents_path,
      manage_text: "View Documents",
      empty_state: {
        title: "No document data",
        description: "Document status statistics will appear here",
        icon: "file-text"
      }
    }
  end

  def recent_activity_data
    {
      activities: recent_activity,
      title: "Recent Activity",
              view_all_path: :models_activities_path,
      view_all_text: "View All Activity"
    }
  end

  def quick_actions_data
    [
      {
        path: :models_users_path,
        text: "Manage Users",
        icon: "people",
        description: "User management and role assignments"
      },
      {
        path: :models_organizations_path,
        text: "Manage Organizations",
        icon: "organization",
        description: "Organization settings and structure"
      },
      {
        path: :models_documents_path,
        text: "View All Documents",
        icon: "file-text",
        description: "Browse and manage all documents"
      },
      {
        path: :models_teams_path,
        text: "Manage Teams",
        icon: "people",
        description: "Team creation and member management"
      }
    ]
  end

  # Context methods for the template
  def template_context
    @template_context
  end
end
