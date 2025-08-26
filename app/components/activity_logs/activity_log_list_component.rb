class ActivityLogs::ActivityLogListComponent < ApplicationComponent
  def initialize(activity_logs:, title: "Activity Log", show_pagination: true, **system_arguments)
    @activity_logs = activity_logs
    @title = title
    @show_pagination = show_pagination
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :activity_logs, :title, :show_pagination, :system_arguments

  def card_classes
    "card #{system_arguments[:class]}"
  end

  def has_activity_logs?
    activity_logs.any?
  end
end
