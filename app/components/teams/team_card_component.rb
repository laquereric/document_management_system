class Teams::TeamCardComponent < ApplicationComponent
  include CardConcerns

  def initialize(team:, current_user: nil, **system_arguments)
    @team = team
    @current_user = current_user
    initialize_card_base(show_actions: true, **system_arguments)
  end

  private

  attr_reader :team, :current_user

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
end
