class Layout::Page::UserRecentActivityComponent < ApplicationComponent
  def initialize(user:, **system_arguments)
    @user = user
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :user, :system_arguments

  def recent_activity
    @recent_activity ||= user.activities.includes(:document).order(created_at: :desc).limit(5)
  end

  def has_activity?
    recent_activity.any?
  end

  def activity_icon(activity)
    case activity.action
    when "created"
      "plus"
    when "updated"
      "pencil"
    else
      "trash"
    end
  end

  def template_context
    {
      user: user,
      recent_activity: recent_activity,
      has_activity?: has_activity?,
      activity_icon: method(:activity_icon)
    }
  end
end
