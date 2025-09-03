require 'spec_helper'

RSpec.describe "Organization Model" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/organization.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/organization.rb')

      # Check for class definition
      expect(content).to include('class Organization < ApplicationRecord')

      # Check for associations
      expect(content).to include('has_many :teams')
      expect(content).to include('has_many :users')

      # Check for validations
      expect(content).to include('validates :name, presence: true')
    end
  end
end
