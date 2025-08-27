class Document < ApplicationRecord
  # Associations
  belongs_to :folder
  belongs_to :author, class_name: 'User'
  belongs_to :status
  belongs_to :scenario_type
  has_many :document_tags, dependent: :destroy
  has_many :tags, through: :document_tags
  has_many :activity_logs, dependent: :destroy
  has_one_attached :file

  # Validations
  validates :title, presence: true
  validates :content, presence: true

  # Scopes
  scope :by_status, ->(status) { where(status: status) }
  scope :by_author, ->(author) { where(author: author) }
  scope :by_folder, ->(folder) { where(folder: folder) }
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  after_update :log_status_change, if: :saved_change_to_status_id?

  # Ransack configuration - define searchable attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[title content created_at updated_at author_id folder_id status_id scenario_type_id]
  end

  # Ransack configuration - define searchable associations
  def self.ransackable_associations(auth_object = nil)
    %w[author folder status scenario_type tags document_tags activity_logs]
  end

  def tag_names
    tags.pluck(:name).join(', ')
  end

  def team
    folder&.team
  end

  def organization
    team&.organization
  end

  private

  def log_status_change
    ActivityLog.create!(
      document: self,
      user: Current.user || author,
      action: 'status_change',
      old_status_id: status_id_before_last_save,
      new_status_id: status_id,
      notes: "Status changed from #{Status.find(status_id_before_last_save).name} to #{status.name}"
    )
  end
end
