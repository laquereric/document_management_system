class Status < ApplicationRecord
  # Associations
  has_many :documents, dependent: :restrict_with_error
  has_many :old_status_logs, class_name: 'ActivityLog', foreign_key: 'old_status_id'
  has_many :new_status_logs, class_name: 'ActivityLog', foreign_key: 'new_status_id'

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :color, presence: true

  def documents_count
    documents.count
  end
end
