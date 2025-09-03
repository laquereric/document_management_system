class Organization < ApplicationRecord
  # Associations
  has_many :users, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :tags, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  def total_users
    users.count
  end

  def total_teams
    teams.count
  end

  def total_tags
    tags.count
  end

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["teams", "users", "tags"]
  end
end
