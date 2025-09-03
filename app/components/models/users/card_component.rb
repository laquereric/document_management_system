class Models::Users::CardComponent < Layout::Card::CardComponent

  def initialize(user:, show_admin_actions: false, context: :general)
    @user = user
    @show_admin_actions = show_admin_actions
    @context = context
    super(show_actions: true)
  end

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
    return false unless helpers.current_user

    helpers.current_user.admin? || helpers.current_user == user
  end

  def can_manage_user?
    return false unless helpers.current_user

    helpers.current_user.admin?
  end

  def show_profile_actions?
    context == :profile
  end

  def show_admin_panel_actions?
    context == :admin && show_admin_actions
  end

  private

  attr_reader :user, :show_admin_actions, :context
end
