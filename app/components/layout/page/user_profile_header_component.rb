class Layout::Page::UserProfileHeaderComponent < ApplicationComponent
  def initialize(user:, current_user:, **system_arguments)
    @user = user
    @current_user = current_user
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :user, :current_user, :system_arguments

  def header_classes
    "d-flex flex-items-center flex-justify-between mb-4 #{system_arguments[:class]}"
  end

  def can_edit_user?
    current_user.admin? || current_user == user
  end

  def can_delete_user?
    current_user.admin? && current_user != user
  end

  def template_context
    {
      user: user,
      current_user: current_user,
      header_classes: header_classes,
      can_edit_user?: can_edit_user?,
      can_delete_user?: can_delete_user?
    }
  end
end
