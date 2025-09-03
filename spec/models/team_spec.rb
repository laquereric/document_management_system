require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'associations' do
    it { should belong_to(:organization) }
    it { should belong_to(:leader).class_name('User') }
    it { should have_many(:team_memberships).dependent(:destroy) }
    it { should have_many(:users).through(:team_memberships) }
    it { should have_many(:folders).dependent(:destroy) }
    it { should have_many(:tags).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end

  describe 'methods' do
    let(:organization) { create(:organization) }
    let(:leader) { create(:user, organization: organization) }
    let(:team) { create(:team, organization: organization, leader: leader) }
    let!(:user1) { create(:user, organization: organization) }
    let!(:user2) { create(:user, organization: organization) }
    let!(:folder1) { create(:folder, team: team) }
    let!(:folder2) { create(:folder, team: team) }
    let!(:tag1) { create(:tag, team: team) }
    let!(:tag2) { create(:tag, team: team) }

    before do
      team.users << user1
      team.users << user2
    end

    describe '#total_members' do
      it 'returns the count of users in the team' do
        expect(team.total_members).to eq(2)
      end
    end

    describe '#total_folders' do
      it 'returns the count of folders in the team' do
        expect(team.total_folders).to eq(2)
      end
    end

    describe '#total_documents' do
      it 'returns the count of documents across all folders in the team' do
        document1 = create(:document, folder: folder1)
        document2 = create(:document, folder: folder2)
        expect(team.total_documents).to eq(2)
      end
    end

    describe '#total_tags' do
      it 'returns the count of tags in the team' do
        expect(team.total_tags).to eq(2)
      end
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(Team.ransackable_attributes).to match_array(%w[name description created_at updated_at organization_id leader_id])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(Team.ransackable_associations).to match_array(%w[organization leader users folders team_memberships tags])
    end
  end
end
