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
    # Handle test data vs real ActiveRecord models
    if team.team_memberships.respond_to?(:count) && !team.team_memberships.is_a?(Array)
      team.team_memberships.count
    else
      team.team_memberships&.length || 0
    end
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
  end

  def can_manage_team?
    current_user&.admin? || team.leader == current_user
  end

  def organization_name
    team.organization&.name || "No Organization"
  end
end
