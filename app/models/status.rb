class Status < ApplicationRecord
  # Associations
  has_many :documents, dependent: :nullify
  has_many :old_status_logs, class_name: 'Activity', foreign_key: 'old_status_id'
  has_many :new_status_logs, class_name: 'Activity', foreign_key: 'new_status_id'

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :color, presence: true

  # Scopes
  scope :active, -> { where(name: 'Active') }
  scope :draft, -> { where(name: 'Draft') }
  scope :archived, -> { where(name: 'Archived') }
  scope :by_color, ->(color) { where(color: color) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[name color created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[documents]
  end

  def document_count
    documents.count
  end

  def css_class
    "status-#{name.downcase.gsub(/\s+/, '-')}"
  end

  def is_active?
    name == 'Active'
  end

  def is_draft?
    name == 'Draft'
  end

  def is_archived?
    name == 'Archived'
  end
end
