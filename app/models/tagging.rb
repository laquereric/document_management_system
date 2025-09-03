class Tagging < ApplicationRecord
  # Associations
  belongs_to :taggable, polymorphic: true
  belongs_to :tag

  # Validations
  validates :tag_id, uniqueness: { scope: [ :taggable_type, :taggable_id ] }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at updated_at tag_id taggable_type taggable_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[tag taggable]
  end

  # Delegate methods to taggable for convenience
  delegate :organization, :team, :folder, to: :taggable, allow_nil: true

  # Get the taggable's name/title for display
  def taggable_name
    case taggable
    when Document
      taggable.title
    when Folder
      taggable.name
    when Organization
      taggable.name
    when Scenario
      taggable.name
    when Team
      taggable.name
    when User
      taggable.name
    else
      taggable&.name || taggable&.title || "Unknown"
    end
  end

  # Get the taggable's class name for display
  def taggable_class_name
    taggable.class.name.downcase
  end

  # Get the tag name
  def tag_name
    tag.name
  end

  # Get the tag color
  def tag_color
    tag.color
  end
end
