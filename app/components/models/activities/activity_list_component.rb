class Models::Activities::ActivityListComponent < ApplicationComponent
  def initialize(activities:, title: "Activity Log", show_pagination: true, **system_arguments)
    @activities = activities
    @title = title
    @show_pagination = show_pagination
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :activities, :title, :show_pagination, :system_arguments

  def card_classes
    "card #{system_arguments[:class]}"
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
      title: title,
      show_pagination: show_pagination,
      render: method(:render),
      paginate: method(:paginate)
    }
  end
end
