class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  belongs_to :organization, optional: true
  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships
  has_many :led_teams, class_name: 'Team', foreign_key: 'leader_id', dependent: :nullify
  has_many :authored_documents, class_name: 'Document', foreign_key: 'author_id', dependent: :destroy
  has_many :activities, dependent: :destroy
  include Taggable

  # Validations
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: %w[admin team_leader member] }

  # Scopes
  scope :admins, -> { where(role: 'admin') }
  scope :team_leaders, -> { where(role: 'team_leader') }
  scope :members, -> { where(role: 'member') }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[name email role created_at updated_at organization_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[organization teams authored_documents activities team_memberships led_teams tags taggings]
  end

  def full_name
    name
  end

  def admin?
    role == 'admin'
  end

  def team_leader?
    role == 'team_leader'
  end

  def member?
    role == 'member'
  end

  def total_tags
    tags.count
  end
end
