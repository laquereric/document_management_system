class Team < ApplicationRecord
  # Associations
  belongs_to :organization
  belongs_to :leader, class_name: "User"
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :folders, dependent: :destroy
  include Taggable

  # Validations
  validates :name, presence: true
  validates :description, presence: true

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[name description created_at updated_at organization_id leader_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[organization leader users folders team_memberships tags taggings]
  end

  def total_members
    users.count
  end

  def total_folders
    folders.count
  end

  def total_documents
    folders.joins(:documents).count
  end

  def total_tags
    tags.count
  end
end
