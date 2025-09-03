class Scenario < ApplicationRecord
  # Associations
  has_many :documents, dependent: :nullify
  include Taggable

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_name, ->(name) { where('name LIKE ?', "%#{name}%") }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["documents", "tags", "taggings"]
  end

  def document_count
    documents.count
  end

  def display_name
    name
  end

  def summary
    description
  end

  def total_tags
    tags.count
  end
end
