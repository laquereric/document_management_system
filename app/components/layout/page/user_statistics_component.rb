class Layout::Page::UserStatisticsComponent < ApplicationComponent
  def initialize(user:, **system_arguments)
    @user = user
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :user, :system_arguments

  def statistics_data
    [
      {
        title: "Teams",
        value: user.teams.count,
        icon: "people",
        color: :accent,
        bg_color: "bg-blue"
      },
      {
        title: "Documents",
        value: user.authored_documents.count,
        icon: "file",
        color: :success,
        bg_color: "bg-green"
      },
      {
        title: "Activities",
        value: user.activities.count,
        icon: "pulse",
        color: :attention,
        bg_color: "bg-purple"
      },
      {
        title: "Days Active",
        value: time_ago_in_words(user.created_at),
        icon: "calendar",
        color: :done,
        bg_color: "bg-orange"
      }
    ]
  end

  def template_context
    {
      user: user,
      statistics_data: statistics_data
    }
  end
end
