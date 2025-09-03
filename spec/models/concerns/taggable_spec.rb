require 'spec_helper'

RSpec.describe "Taggable Concern" do
  describe "file structure" do
    it "exists in the correct location" do
      expect(File.exist?('app/models/concerns/taggable.rb')).to be true
    end

    it "has the correct file content structure" do
      content = File.read('app/models/concerns/taggable.rb')

      # Check for module definition
      expect(content).to include('module Taggable')

      # Check for extend
      expect(content).to include('extend ActiveSupport::Concern')

      # Check for included block
      expect(content).to include('included do')

      # Check for associations
      expect(content).to include('has_many :taggings')
      expect(content).to include('has_many :tags')

      # Check for methods
      expect(content).to include('def add_tag')
      expect(content).to include('def remove_tag')
      expect(content).to include('def has_tag?')
      expect(content).to include('def tag_names')
      expect(content).to include('def tag_name_array')
      expect(content).to include('def tags_by_name')
      expect(content).to include('def tags_by_color')
      expect(content).to include('def tag_count')
      expect(content).to include('def tagged?')
      expect(content).to include('def tags_in_context')
    end
  end
end
