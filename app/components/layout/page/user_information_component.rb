class Layout::Page::UserInformationComponent < ApplicationComponent
  def initialize(user:, current_user:, **system_arguments)
    @user = user
    @current_user = current_user
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :user, :current_user, :system_arguments

  def role_label_scheme
    case user.role
    when "admin"
      :danger
    when "team_leader"
      :warning
    else
      :secondary
    end
  end

  def can_toggle_role?
    current_user.admin? && current_user != user
  end

  def template_context
    {
      user: user,
      current_user: current_user,
      role_label_scheme: role_label_scheme,
      can_toggle_role?: can_toggle_role?
    }
  end
end
