class Tag < ApplicationRecord
  # Associations
  belongs_to :organization, optional: true
  belongs_to :team, optional: true
  belongs_to :folder, optional: true
  has_many :taggings, dependent: :destroy
  has_many :taggables, through: :taggings, source: :taggable, source_type: 'Document'

  # Validations
  validates :name, presence: true, uniqueness: { scope: [:organization_id, :team_id, :folder_id] }
  validates :color, presence: true

  # Scopes
  scope :popular, -> { joins(:documents).group('tags.id').order('COUNT(documents.id) DESC') }
  scope :by_organization, ->(organization) { where(organization: organization) }
  scope :by_team, ->(team) { where(team: team) }
  scope :by_folder, ->(folder) { where(folder: folder) }
  scope :global, -> { where(organization_id: nil, team_id: nil, folder_id: nil) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["color", "created_at", "id", "id_value", "name", "updated_at", "organization_id", "team_id", "folder_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["taggings", "taggables", "organization", "team", "folder"]
  end

  # Get all taggable objects of a specific type
  def taggables_of_type(type)
    taggings.where(taggable_type: type).map(&:taggable)
  end

  # Get all documents with this tag
  def documents
    taggables_of_type('Document')
  end

  # Get all folders with this tag
  def folders
    taggables_of_type('Folder')
  end

  # Get all organizations with this tag
  def organizations
    taggables_of_type('Organization')
  end

  # Get all scenarios with this tag
  def scenarios
    taggables_of_type('Scenario')
  end

  # Get all teams with this tag
  def teams
    taggables_of_type('Team')
  end

  # Get all users with this tag
  def users
    taggables_of_type('User')
  end

  def document_count
    documents.count
  end

  def css_class
    "tag-#{name.downcase.gsub(/\s+/, '-')}"
  end

  def context
    if organization_id.present?
      'organization'
    elsif team_id.present?
      'team'
    elsif folder_id.present?
      'folder'
    else
      'global'
    end
  end

  def context_name
    if organization_id.present?
      organization&.name
    elsif team_id.present?
      team&.name
    elsif folder_id.present?
      folder&.name
    end
  end
end
