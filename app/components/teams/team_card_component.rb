class Teams::TeamCardComponent < ApplicationComponent
  def initialize(team:, current_user: nil, **system_arguments)
    @team = team
    @current_user = current_user
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :team, :current_user, :system_arguments

  def card_classes
    "Box h-100 #{system_arguments[:class]}"
  end

  def member_count
    team.team_memberships.count
  end

  def document_count
    team.folders.joins(:documents).count
  end

  def can_manage_team?
    current_user&.admin? || team.leader == current_user
  end

  def organization_name
    team.organization&.name || "No Organization"
  end
end
