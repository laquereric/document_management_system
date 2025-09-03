class TeamMembership < ApplicationRecord
  # Associations
  belongs_to :team
  belongs_to :user

  # Validations
  validates :user_id, uniqueness: { scope: :team_id }

  # Scopes
  scope :by_user, ->(user) { where(user: user) }
  scope :by_team, ->(team) { where(team: team) }
  scope :by_organization, ->(organization) { joins(:team).where(teams: { organization: organization }) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at updated_at user_id team_id joined_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user team]
  end

  def organization
    team.organization
  end

  def user_name
    user.name
  end

  def team_name
    team.name
  end

  # Callbacks
  before_create :set_joined_at

  private

  def set_joined_at
    self.joined_at ||= Time.current
  end
end
