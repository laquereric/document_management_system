class Document < ApplicationRecord
  # Associations
  belongs_to :folder
  belongs_to :author, class_name: "User"
  belongs_to :status
  belongs_to :scenario
  include Taggable
  has_many :activities, dependent: :destroy
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
    %w[title content created_at updated_at author_id folder_id status_id scenario_id]
  end

  # Ransack configuration - define searchable associations
  def self.ransackable_associations(auth_object = nil)
    %w[author folder status scenario tags taggings activities]
  end

  def total_tags
    tags.count
  end

  def team
    folder&.team
  end

  def organization
    team&.organization
  end

  def has_file?
    file.attached? && file.present?
  end

  def file_extension
    return nil unless has_file?
    file.filename.to_s.split(".").last&.upcase
  end

  def file_icon
    case file_extension
    when "PDF"
      "file-pdf"
    when "DOCX", "DOC"
      "file-word"
    when "XLSX", "XLS"
      "file-spreadsheet"
    when "PPTX", "PPT"
      "file-presentation"
    when "TXT"
      "file-text"
    else
      "file"
    end
  end

  private

  def log_status_change
    Activity.create!(
      document: self,
      user: Current.user || author,
      action: "status_change",
      old_status_id: status_id_before_last_save,
      new_status_id: status_id
    )
  end
end
