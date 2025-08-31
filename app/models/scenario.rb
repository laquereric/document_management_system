class Scenario < ApplicationRecord
  # Associations
  has_many :documents, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  def documents_count
    documents.count
  end

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["documents"]
  end
end
