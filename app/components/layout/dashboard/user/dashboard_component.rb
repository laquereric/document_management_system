class User::Dashboard::DashboardComponent < ApplicationComponent
  def initialize(stats:, recent_documents:, recent_activity:, **system_arguments)
    @stats = stats
    @recent_documents = recent_documents
    @recent_activity = recent_activity
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :stats, :recent_documents, :recent_activity, :system_arguments

  def dashboard_classes
    "container-lg px-3 #{system_arguments[:class]}"
  end

  def statistics_data
    [
      {
        title: "My Documents",
        value: stats[:total_documents],
        icon: "file-text",
        color: "accent"
      },
      {
        title: "My Teams",
        value: stats[:total_teams],
        icon: "people",
        color: "success"
      },
      {
        title: "Teams I Lead",
        value: stats[:led_teams],
        icon: "person-badge",
        color: "attention"
      },
      {
        title: "Pending Documents",
        value: stats[:pending_documents],
        icon: "clock",
        color: "severe"
      }
    ]
  end

  def header_data
    {
      title: "Dashboard",
      description: "Welcome back, #{current_user.name}",
      icon: "home"
    }
  end

  # Context methods for the template
  def template_context
    {
      dashboard_classes: dashboard_classes,
      statistics_data: statistics_data,
      header_data: header_data,
      recent_documents: recent_documents,
      recent_activity: recent_activity,
      current_user: current_user
    }
  end
end
