require 'spec_helper'

RSpec.describe "Scenario Model" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/scenario.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/scenario.rb')

      # Check for class definition
      expect(content).to include('class Scenario < ApplicationRecord')

      # Check for associations
      expect(content).to include('has_many :documents')

      # Check for validations
      expect(content).to include('validates :name, presence: true')

      # Check for scopes
      expect(content).to include('scope :recent')
      expect(content).to include('scope :by_name')
    end
  end
end
