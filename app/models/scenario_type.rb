class ScenarioType < ApplicationRecord
  # Associations
  has_many :documents, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  def documents_count
    documents.count
  end
end
