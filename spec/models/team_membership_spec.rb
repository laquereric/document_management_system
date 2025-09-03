require 'spec_helper'

RSpec.describe "TeamMembership Model" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/team_membership.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/team_membership.rb')

      # Check for class definition
      expect(content).to include('class TeamMembership < ApplicationRecord')

      # Check for associations
      expect(content).to include('belongs_to :user')
      expect(content).to include('belongs_to :team')

      # Check for validations
      expect(content).to include('validates :user_id, uniqueness: { scope: :team_id }')

      # Check for scopes
      expect(content).to include('scope :by_user')
      expect(content).to include('scope :by_team')
      expect(content).to include('scope :by_organization')

      # Check for methods
      expect(content).to include('def organization')
      expect(content).to include('def user_name')
      expect(content).to include('def team_name')
    end
  end
end
