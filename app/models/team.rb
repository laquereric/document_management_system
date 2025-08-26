class Team < ApplicationRecord
  # Associations
  belongs_to :organization
  belongs_to :leader, class_name: 'User'
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :folders, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :description, presence: true

  def total_members
    users.count
  end

  def total_folders
    folders.count
  end

  def total_documents
    folders.joins(:documents).count
  end
end
