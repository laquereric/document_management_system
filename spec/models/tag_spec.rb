require 'spec_helper'

RSpec.describe "Tag Model" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/tag.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/tag.rb')

      # Check for class definition
      expect(content).to include('class Tag < ApplicationRecord')

      # Check for associations
      expect(content).to include('belongs_to :organization, optional: true')
      expect(content).to include('belongs_to :team, optional: true')
      expect(content).to include('belongs_to :folder, optional: true')
      expect(content).to include('has_many :taggings, dependent: :destroy')
      expect(content).to include('has_many :taggables, through: :taggings')

      # Check for validations
      expect(content).to include('validates :name, presence: true, uniqueness: { scope: [ :organization_id, :team_id, :folder_id ] }')

      # Check for scopes
      expect(content).to include('scope :popular')
      expect(content).to include('scope :by_organization')
      expect(content).to include('scope :by_team')
      expect(content).to include('scope :global')

      # Check for methods
      expect(content).to include('def documents')
      expect(content).to include('def folders')
      expect(content).to include('def context')
    end
  end
end
