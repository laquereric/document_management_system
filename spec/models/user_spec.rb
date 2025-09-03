require 'spec_helper'

RSpec.describe "User Model" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/user.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/user.rb')

      # Check for class definition
      expect(content).to include('class User < ApplicationRecord')

      # Check for Devise modules
      expect(content).to include('devise :database_authenticatable, :registerable,')
      expect(content).to include(':recoverable, :rememberable, :validatable')

      # Check for associations
      expect(content).to include('belongs_to :organization, optional: true')
      expect(content).to include('has_many :team_memberships, dependent: :destroy')
      expect(content).to include('has_many :teams, through: :team_memberships')
      expect(content).to include('has_many :authored_documents, class_name: "Document"')
      expect(content).to include('has_many :activities, dependent: :destroy')

      # Check for validations
      expect(content).to include('validates :name, presence: true')
      expect(content).to include('validates :role, presence: true, inclusion: { in: %w[admin team_leader member] }')

      # Check for scopes
      expect(content).to include('scope :admins')
      expect(content).to include('scope :team_leaders')
      expect(content).to include('scope :members')

      # Check for methods
      expect(content).to include('def admin?')
      expect(content).to include('def team_leader?')
      expect(content).to include('def member?')
    end
  end
end
