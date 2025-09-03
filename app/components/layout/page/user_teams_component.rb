class Layout::Page::UserTeamsComponent < ApplicationComponent
  def initialize(user:, **system_arguments)
    @user = user
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :user, :system_arguments

  def has_teams?
    user.teams.any?
  end

  def template_context
    {
      user: user,
      has_teams?: has_teams?
    }
  end
end
