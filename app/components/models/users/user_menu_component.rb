# User menu component for the header

class Models::Users::UserMenuComponent < ApplicationComponent
  def initialize(user:, **system_arguments)
    @user = user
    @system_arguments = merge_system_arguments(system_arguments)
  end

  def before_render
    @menu_items = build_menu_items
  end

  # Public method for testing
  def menu_items
    @menu_items || build_menu_items
  end

  private

  attr_reader :user, :system_arguments

  def build_menu_items
    [
      {
        label: "Profile",
        icon: :person,
        href: "#" # Would link to user profile
      },
      {
        label: "Settings",
        icon: :gear,
        href: "#" # Would link to user settings
      },
      {
        label: "Help",
        icon: :question,
        href: "#"
      },
      :divider,
      {
        label: "Sign Out",
        icon: :x,
        href: "#", # Will be set in template
        method: :delete,
        classes: "color-fg-danger"
      }
    ]
  end

  def user_initials
    return "" if user.nil? || user.email.blank?
    names = user.email.split("@").first.split(".")
    names.map(&:first).join.upcase[0..1]
  end

  # Context methods for the template
  def template_context
    {
      menu_items: menu_items,
      user_initials: user_initials,
      user: user,
      destroy_user_session_path: helpers.destroy_user_session_path,
      user_path: helpers.user_path,
      edit_user_path: helpers.edit_user_path
    }
  end
end
