class Layout::Page::UserRoleManagementComponent < ApplicationComponent
  def initialize(user:, current_user:, **system_arguments)
    @user = user
    @current_user = current_user
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :user, :current_user, :system_arguments

  def should_show?
    current_user.admin? && current_user != user
  end

  def role_label_scheme
    user.admin? ? :danger : :secondary
  end

  def template_context
    {
      user: user,
      current_user: current_user,
      should_show?: should_show?,
      role_label_scheme: role_label_scheme
    }
  end
end
