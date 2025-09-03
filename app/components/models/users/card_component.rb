class Models::Users::CardComponent < ApplicationComponent
  def initialize(user:, current_user: nil, show_admin_actions: false, context: :general)
    @user = user
    @current_user = current_user
    @show_admin_actions = show_admin_actions
    @context = context
  end

  def card_classes
    "Box p-3"
  end

  def document_count
    @document_count ||= safe_count(user.authored_documents)
  end

  def team_count
    @team_count ||= safe_count(user.teams)
  end

  def activity_count
    @activity_count ||= safe_count(user.activities)
  end

  def organization_name
    safe_name(user.organization, "None")
  end

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

  def can_edit_user?
    return false unless current_user

    current_user.admin? || current_user == user
  end

  def can_manage_user?
    return false unless current_user

    current_user.admin?
  end

  def show_profile_actions?
    context == :profile
  end

  def show_admin_panel_actions?
    context == :admin && show_admin_actions
  end

  private

  attr_reader :user, :current_user, :show_admin_actions, :context

  def safe_name(object, default = "Unknown")
    object&.name || default
  end

  def safe_count(collection)
    collection&.count || 0
  end
end
