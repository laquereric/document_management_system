require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'associations' do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_many(:teams).dependent(:destroy) }
    it { should have_many(:tags).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'methods' do
    let(:organization) { create(:organization) }
    let!(:user1) { create(:user, organization: organization) }
    let!(:user2) { create(:user, organization: organization) }
    let!(:team1) { create(:team, organization: organization) }
    let!(:team2) { create(:team, organization: organization) }
    let!(:tag1) { create(:tag, organization: organization) }
    let!(:tag2) { create(:tag, organization: organization) }

    describe '#total_users' do
      it 'returns the count of users in the organization' do
        expect(organization.total_users).to eq(4) # 2 users + 2 team leaders
      end
    end

    describe '#total_teams' do
      it 'returns the count of teams in the organization' do
        expect(organization.total_teams).to eq(2)
      end
    end

    describe '#total_tags' do
      it 'returns the count of tags in the organization' do
        expect(organization.total_tags).to eq(2)
      end
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(Organization.ransackable_attributes).to match_array(%w[created_at description id id_value name updated_at])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(Organization.ransackable_associations).to match_array(%w[teams users tags])
    end
  end
end
