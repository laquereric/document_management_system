class ActivityLog < ApplicationRecord
  # Associations
  belongs_to :document
  belongs_to :user
  belongs_to :old_status, class_name: 'Status', optional: true
  belongs_to :new_status, class_name: 'Status', optional: true

  # Validations
  validates :action, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_document, ->(document) { where(document: document) }
  scope :by_user, ->(user) { where(user: user) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[action notes created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[document user old_status new_status]
  end

  def action_description
    case action
    when 'status_change'
      "Changed status from #{old_status&.name} to #{new_status&.name}"
    when 'created'
      'Document created'
    when 'updated'
      'Document updated'
    else
      action.humanize
    end
  end
end
