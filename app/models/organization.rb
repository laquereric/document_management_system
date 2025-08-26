class Organization < ApplicationRecord
  # Associations
  has_many :users, dependent: :destroy
  has_many :teams, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  def total_users
    users.count
  end

  def total_teams
    teams.count
  end
end
