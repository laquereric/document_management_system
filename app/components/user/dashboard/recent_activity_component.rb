class User::Dashboard::RecentActivityComponent < ApplicationComponent
  def initialize(activities:, limit: 10, **system_arguments)
    @activities = activities.limit(limit)
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :activities, :system_arguments

  def card_classes
    "Box #{system_arguments[:class]}"
  end

  def has_activities?
    activities.any?
  end

  # Context methods for the template
  def template_context
    {
      card_classes: card_classes,
      has_activities?: has_activities?,
      activities: activities,
      activities_path: activities_path,
      document_path: method(:document_path),
      time_ago_in_words: method(:time_ago_in_words)
    }
  end
end
