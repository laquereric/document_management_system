require 'spec_helper'

RSpec.describe "Team Model" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/team.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/team.rb')

      # Check for class definition
      expect(content).to include('class Team < ApplicationRecord')

      # Check for associations
      expect(content).to include('belongs_to :organization')
      expect(content).to include('has_many :team_memberships')
      expect(content).to include('has_many :users')
      expect(content).to include('has_many :folders')

      # Check for validations
      expect(content).to include('validates :name, presence: true')
    end
  end
end
