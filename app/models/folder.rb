class Folder < ApplicationRecord
  # Associations
  belongs_to :parent_folder, class_name: 'Folder', optional: true
  belongs_to :team
  has_many :subfolders, class_name: 'Folder', foreign_key: 'parent_folder_id', dependent: :destroy
  has_many :documents, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: { scope: [:parent_folder_id, :team_id] }

  # Scopes
  scope :root_folders, -> { where(parent_folder_id: nil) }
  scope :by_team, ->(team) { where(team: team) }

  def root?
    parent_folder_id.nil?
  end

  def path
    return name if root?
    "#{parent_folder.path} / #{name}"
  end

  def total_documents
    documents.count + subfolders.sum(&:total_documents)
  end

  def organization
    team&.organization
  end
end
