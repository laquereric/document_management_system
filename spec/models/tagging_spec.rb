require 'spec_helper'

RSpec.describe "Tagging Model" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/tagging.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/tagging.rb')

      # Check for class definition
      expect(content).to include('class Tagging < ApplicationRecord')

      # Check for polymorphic associations
      expect(content).to include('belongs_to :taggable, polymorphic: true')
      expect(content).to include('belongs_to :tag')

      # Check for validations
      expect(content).to include('validates :tag_id, uniqueness: { scope: [ :taggable_type, :taggable_id ] }')

      # Check for methods
      expect(content).to include('def taggable_name')
      expect(content).to include('def taggable_class_name')
      expect(content).to include('def tag_name')
      expect(content).to include('def tag_color')
    end
  end
end
