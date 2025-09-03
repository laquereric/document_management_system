class Models::Teams::TeamCardComponent < Layout::CardComponent

  def initialize(team:, current_user: nil, admin_context: false, **system_arguments)
    @team = team
    @current_user = current_user
    @admin_context = admin_context
    initialize_card_base(show_actions: true, **system_arguments)
  end

  private

  attr_reader :team, :current_user, :admin_context

  def card_classes
    "#{base_card_classes} h-100 #{system_arguments[:class]}".strip
  end

  def member_count
    safe_count(team.team_memberships)
  end

  def document_count
    # Handle test data (OpenStruct) vs real ActiveRecord models
    if team.folders.respond_to?(:joins)
      # Real ActiveRecord relation
      team.folders.joins(:documents).count
    else
      # Test data - count documents in folders array
      team.folders.sum { |folder| folder.documents&.count || 0 }
    end
  rescue
    0
  end

  def can_manage_team?
    current_user&.admin? || team.leader == current_user
  end

  def organization_name
    safe_name(team.organization, "No Organization")
  end

  def admin_context?
    admin_context
  end

  def admin_team_path
    models_team_path(team)
  end

  def edit_admin_team_path
    models_edit_team_path(team)
  end

  # Context methods for the template
  def template_context
    {
      card_classes: card_classes,
      member_count: member_count,
      document_count: document_count,
      can_manage_team?: can_manage_team?,
      organization_name: organization_name,
      admin_context?: admin_context?,
      team: team,
      current_user: current_user,
      admin_context: admin_context,
      admin_team_path: method(:admin_team_path),
      edit_admin_team_path: method(:edit_admin_team_path),
      organization_team_path: method(:organization_team_path),
      edit_organization_team_path: method(:edit_organization_team_path),
      link_to: method(:link_to)
    }
  end
end
