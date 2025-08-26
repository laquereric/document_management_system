class TeamMembership < ApplicationRecord
  # Associations
  belongs_to :team
  belongs_to :user

  # Validations
  validates :user_id, uniqueness: { scope: :team_id }

  # Callbacks
  before_create :set_joined_at

  private

  def set_joined_at
    self.joined_at ||= Time.current
  end
end
