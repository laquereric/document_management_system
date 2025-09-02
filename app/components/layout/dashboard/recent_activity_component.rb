class Layout::Dashboard::RecentActivityComponent < ApplicationComponent
  def initialize(activities:, title: "Recent Activity", view_all_path: nil, view_all_text: "View All Activity", limit: 10, **system_arguments)
    @activities = activities.respond_to?(:limit) ? activities.limit(limit) : activities.first(limit)
    @title = title
    @view_all_path = view_all_path
    @view_all_text = view_all_text
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :activities, :title, :view_all_path, :view_all_text, :system_arguments

  def card_classes
    "Box #{system_arguments[:class]}"
  end

  def has_activities?
    activities.any?
  end

  def show_view_all_link?
    view_all_path.present?
  end

  # Context methods for the template
  def template_context
    {
      card_classes: card_classes,
      has_activities?: has_activities?,
      activities: activities,
      title: title,
      view_all_path: view_all_path,
      view_all_text: view_all_text,
      show_view_all_link?: show_view_all_link?,
      document_path: method(:document_path),
      time_ago_in_words: method(:time_ago_in_words)
    }
  end
end
