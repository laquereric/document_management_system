class Activity < ApplicationRecord
  # Associations
  belongs_to :document
  belongs_to :user
  belongs_to :old_status, class_name: 'Status', optional: true
  belongs_to :new_status, class_name: 'Status', optional: true

  # Validations
  validates :action, presence: true, inclusion: { in: %w[created updated deleted status_change tagged untagged] }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_document, ->(document) { where(document: document) }
  scope :by_user, ->(user) { where(user: user) }
  scope :by_action, ->(action) { where(action: action) }
  scope :status_changes, -> { where(action: 'status_change') }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[action notes created_at updated_at user_id document_id old_status_id new_status_id]
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

  def description
    case action
    when 'status_change'
      "changed status #{status_change_description}"
    when 'created'
      'created document'
    when 'updated'
      'updated document'
    when 'deleted'
      'deleted document'
    when 'tagged'
      'added tag to document'
    when 'untagged'
      'removed tag from document'
    else
      action.humanize.downcase
    end
  end

  def action_verb
    case action
    when 'status_change'
      'changed status'
    when 'created'
      'created'
    when 'updated'
      'updated'
    when 'deleted'
      'deleted'
    when 'tagged'
      'tagged'
    when 'untagged'
      'removed tag'
    else
      action.humanize.downcase
    end
  end

  def status_change_description
    if old_status && new_status
      "from #{old_status.name} to #{new_status.name}"
    elsif old_status
      "from #{old_status.name}"
    elsif new_status
      "to #{new_status.name}"
    end
  end

  def document_title
    document.title
  end

  def user_name
    user.name
  end
end
