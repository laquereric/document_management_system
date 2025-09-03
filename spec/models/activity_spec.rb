require 'spec_helper'

RSpec.describe "Activity Model" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/activity.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/activity.rb')

      # Check for class definition
      expect(content).to include('class Activity < ApplicationRecord')

      # Check for associations
      expect(content).to include('belongs_to :document')
      expect(content).to include('belongs_to :user')
      expect(content).to include('belongs_to :old_status, class_name: "Status"')
      expect(content).to include('belongs_to :new_status, class_name: "Status"')

      # Check for validations
      expect(content).to include('validates :action, presence: true, inclusion: { in: %w[created updated deleted status_change tagged untagged] }')

      # Check for scopes
      expect(content).to include('scope :recent')
      expect(content).to include('scope :by_document')
      expect(content).to include('scope :by_user')
      expect(content).to include('scope :by_action')
      expect(content).to include('scope :status_changes')

      # Check for methods
      expect(content).to include('def action_description')
      expect(content).to include('def description')
      expect(content).to include('def action_verb')
    end
  end
end
