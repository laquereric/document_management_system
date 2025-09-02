class Admin::Dashboard::DashboardComponent < ApplicationComponent
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
        color: "accent"
      },
      {
        title: "Organizations",
        value: total_organizations,
        icon: "organization",
        color: "success"
      },
      {
        title: "Total Documents",
        value: total_documents,
        icon: "file-text",
        color: "attention"
      },
      {
        title: "Total Folders",
        value: total_folders,
        icon: "file-directory",
        color: "done"
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

  # Context methods for the template
  def template_context
    {
      dashboard_classes: dashboard_classes,
      statistics_data: statistics_data,
      header_data: header_data,
      users_by_role: users_by_role,
      documents_by_status: documents_by_status,
      recent_activity: recent_activity
    }
  end
end
