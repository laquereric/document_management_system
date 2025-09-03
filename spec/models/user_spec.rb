require 'spec_helper'

# Load Rails environment for model testing
begin
  require_relative '../../config/environment'
rescue => e
  puts "Could not load Rails environment: #{e.message}"
  exit 1
end

RSpec.describe User, type: :model do
  # Include FactoryBot methods
  include FactoryBot::Syntax::Methods
  describe "basic functionality" do
    it "is a valid model" do
      expect(User).to be_a(Class)
      expect(User.ancestors).to include(ApplicationRecord)
    end

    it "has the correct associations" do
      expect(User.reflect_on_association(:organization)).to be_present
      expect(User.reflect_on_association(:team_memberships)).to be_present
      expect(User.reflect_on_association(:teams)).to be_present
      expect(User.reflect_on_association(:authored_documents)).to be_present
      expect(User.reflect_on_association(:activities)).to be_present
    end

    it "has the correct validations" do
      expect(User.validators_on(:name)).to be_present
      expect(User.validators_on(:role)).to be_present
    end

    it "has the correct scopes" do
      # Check that the scope methods exist
      expect(User).to respond_to(:admins)
      expect(User).to respond_to(:team_leaders)
      expect(User).to respond_to(:members)
    end

    it "has the correct methods" do
      expect(User.instance_methods).to include(:admin?, :team_leader?, :member?)
    end
  end

  describe "instance methods" do
    let(:user) { build(:user) }

    it "responds to role checking methods" do
      expect(user).to respond_to(:admin?)
      expect(user).to respond_to(:team_leader?)
      expect(user).to respond_to(:member?)
    end
  end
end
