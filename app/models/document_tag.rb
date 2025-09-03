class DocumentTag < ApplicationRecord
  # Associations
  belongs_to :document
  belongs_to :tag

  # Validations
  validates :document_id, uniqueness: { scope: :tag_id }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at updated_at document_id tag_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[document tag]
  end

  def organization
    document.organization
  end

  def team
    document.team
  end

  def folder
    document.folder
  end

  def tag_name
    tag.name
  end

  def tag_color
    tag.color
  end

  def document_title
    document.title
  end
end
