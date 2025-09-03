require 'spec_helper'

# Load Rails environment for model testing
begin
  require_relative '../../config/environment'
rescue => e
  puts "Could not load Rails environment: #{e.message}"
  exit 1
end

RSpec.describe Document, type: :model do
  # Include FactoryBot methods
  include FactoryBot::Syntax::Methods

  describe "basic functionality" do
    it "is a valid model" do
      expect(Document).to be_a(Class)
      expect(Document.ancestors).to include(ApplicationRecord)
    end

    it "has the correct associations" do
      expect(Document.reflect_on_association(:folder)).to be_present
      expect(Document.reflect_on_association(:author)).to be_present
      expect(Document.reflect_on_association(:status)).to be_present
      expect(Document.reflect_on_association(:scenario)).to be_present
      expect(Document.reflect_on_association(:activities)).to be_present
    end

    it "has the correct validations" do
      expect(Document.validators_on(:title)).to be_present
      expect(Document.validators_on(:content)).to be_present
    end

    it "has the correct scopes" do
      expect(Document).to respond_to(:by_status)
      expect(Document).to respond_to(:by_author)
      expect(Document).to respond_to(:by_folder)
      expect(Document).to respond_to(:recent)
    end

    it "has the correct methods" do
      expect(Document.instance_methods).to include(:total_tags, :team, :organization, :has_file?, :file_extension, :file_icon)
    end

    it "has ransackable configuration" do
      expect(Document.ransackable_attributes).to include("title", "content", "author_id")
      expect(Document.ransackable_associations).to include("author", "folder", "status")
    end
  end

  describe "instance methods" do
    let(:document) { build(:document) }

    it "responds to file handling methods" do
      expect(document).to respond_to(:has_file?)
      expect(document).to respond_to(:file_extension)
      expect(document).to respond_to(:file_icon)
    end
  end
end
