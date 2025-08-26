class Tag < ApplicationRecord
  # Associations
  has_many :document_tags, dependent: :destroy
  has_many :documents, through: :document_tags

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :color, presence: true

  # Scopes
  scope :popular, -> { joins(:documents).group('tags.id').order('COUNT(documents.id) DESC') }

  def usage_count
    documents.count
  end
end
