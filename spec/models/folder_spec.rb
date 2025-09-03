require 'spec_helper'

RSpec.describe "Folder Model" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/folder.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/folder.rb')

      # Check for class definition
      expect(content).to include('class Folder < ApplicationRecord')

      # Check for associations
      expect(content).to include('belongs_to :parent_folder, class_name: "Folder"')
      expect(content).to include('belongs_to :team')
      expect(content).to include('has_many :subfolders, class_name: "Folder"')
      expect(content).to include('has_many :documents, dependent: :destroy')

      # Check for validations
      expect(content).to include('validates :name, presence: true')
      expect(content).to include('validates :name, uniqueness: { scope: [ :parent_folder_id, :team_id ] }')

      # Check for scopes
      expect(content).to include('scope :root_folders')
      expect(content).to include('scope :by_team')

      # Check for methods
      expect(content).to include('def root?')
      expect(content).to include('def path')
      expect(content).to include('def total_documents')
    end
  end
end
