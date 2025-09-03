require 'spec_helper'

RSpec.describe "DocumentTag Model" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/document_tag.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/document_tag.rb')

      # Check for class definition
      expect(content).to include('class DocumentTag < ApplicationRecord')

      # Check for associations
      expect(content).to include('belongs_to :document')
      expect(content).to include('belongs_to :tag')

      # Check for validations
      expect(content).to include('validates :document_id, uniqueness: { scope: :tag_id }')

      # Check for methods
      expect(content).to include('def organization')
      expect(content).to include('def team')
      expect(content).to include('def folder')
      expect(content).to include('def tag_name')
      expect(content).to include('def tag_color')
      expect(content).to include('def document_title')
    end
  end
end
