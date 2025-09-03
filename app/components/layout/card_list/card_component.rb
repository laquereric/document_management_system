class Layout::CardComponent < ApplicationComponent

  def initialize(user:, show_admin_actions: false, context: :general)
    @user = user
    @show_admin_actions = show_admin_actions
    @context = context
    initialize_card_base(show_actions: true)
  end

  private

  attr_reader :user, :show_admin_actions, :context

  def card_classes
    base_card_classes
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
    safe_name(user.organization, 'None')
  end

  def role_label_class
    super(user.role)
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

  # Context methods for the template
  def template_context
    {
      user: user,
      show_admin_actions: show_admin_actions,
      context: context,
      card_classes: card_classes,
      document_count: document_count,
      team_count: team_count,
      activity_count: activity_count,
      organization_name: organization_name,
      role_label_class: role_label_class,
      can_edit_user?: can_edit_user?,
      can_manage_user?: can_manage_user?,
      show_profile_actions?: show_profile_actions?,
      show_admin_panel_actions?: show_admin_panel_actions?
    }
  end
end
