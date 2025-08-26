# User menu component for the header

class Ui::UserMenuComponent < ApplicationComponent
  def initialize(user:, **system_arguments)
    @user = user
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :user, :system_arguments

  def menu_items
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
        icon: :sign_out,
        href: destroy_user_session_path,
        method: :delete,
        classes: "color-fg-danger"
      }
    ]
  end

  def user_initials
    names = user.email.split('@').first.split('.')
    names.map(&:first).join.upcase[0..1]
  end
end
