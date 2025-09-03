require 'spec_helper'

RSpec.describe "Status Model" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/status.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/status.rb')

      # Check for class definition
      expect(content).to include('class Status < ApplicationRecord')

      # Check for associations
      expect(content).to include('has_many :documents')

      # Check for validations
      expect(content).to include('validates :name, presence: true')
      expect(content).to include('validates :color, presence: true')

      # Check for scopes
      expect(content).to include('scope :active')
      expect(content).to include('scope :draft')
      expect(content).to include('scope :archived')
      expect(content).to include('scope :by_color')
    end
  end
end
