require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'associations' do
    it { should belong_to(:organization) }
    it { should belong_to(:leader).class_name('User') }
    it { should have_many(:team_memberships).dependent(:destroy) }
    it { should have_many(:users).through(:team_memberships) }
    it { should have_many(:folders).dependent(:destroy) }
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:tags).through(:taggings) }
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
    let!(:tag1) { create(:tag) }
    let!(:tag2) { create(:tag) }

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
        team.add_tag(tag1)
        team.add_tag(tag2)
        expect(team.total_tags).to eq(2)
      end
    end
  end

  describe 'tagging functionality' do
    let(:organization) { create(:organization) }
    let(:leader) { create(:user, organization: organization) }
    let(:team) { create(:team, organization: organization, leader: leader) }
    let(:tag1) { create(:tag, name: 'Development') }
    let(:tag2) { create(:tag, name: 'Frontend') }
    let(:tag3) { create(:tag, name: 'Backend') }

    describe '#add_tag' do
      it 'adds a tag to the team' do
        team.add_tag(tag1)
        expect(team.tags).to include(tag1)
      end

      it 'does not add duplicate tags' do
        team.add_tag(tag1)
        team.add_tag(tag1)
        expect(team.tags.count).to eq(1)
      end
    end

    describe '#remove_tag' do
      it 'removes a tag from the team' do
        team.add_tag(tag1)
        team.remove_tag(tag1)
        expect(team.tags).not_to include(tag1)
      end
    end

    describe '#has_tag?' do
      it 'returns true when team has the tag' do
        team.add_tag(tag1)
        expect(team.has_tag?(tag1)).to be true
      end

      it 'returns false when team does not have the tag' do
        expect(team.has_tag?(tag1)).to be false
      end
    end

    describe '#tag_names' do
      it 'returns comma-separated tag names' do
        team.add_tag(tag1)
        team.add_tag(tag2)
        expect(team.tag_names).to eq('Development, Frontend')
      end

      it 'returns empty string when no tags' do
        expect(team.tag_names).to eq('')
      end
    end

    describe '#tag_name_array' do
      it 'returns array of tag names' do
        team.add_tag(tag1)
        team.add_tag(tag2)
        expect(team.tag_name_array).to eq([ 'Development', 'Frontend' ])
      end

      it 'returns empty array when no tags' do
        expect(team.tag_name_array).to eq([])
      end
    end

    describe '#tags_by_name' do
      it 'returns tags matching the given names' do
        team.add_tag(tag1)
        team.add_tag(tag2)
        team.add_tag(tag3)

        result = team.tags_by_name('Development', 'Frontend')
        expect(result).to include(tag1, tag2)
        expect(result).not_to include(tag3)
      end
    end

    describe '#tags_by_color' do
      it 'returns tags matching the given color' do
        team.add_tag(tag1)
        team.add_tag(tag2)

        result = team.tags_by_color(tag1.color)
        expect(result).to include(tag1)
        expect(result).not_to include(tag2)
      end
    end

    describe '#tag_count' do
      it 'returns the count of tags' do
        team.add_tag(tag1)
        team.add_tag(tag2)
        expect(team.tag_count).to eq(2)
      end

      it 'returns 0 when no tags' do
        expect(team.tag_count).to eq(0)
      end
    end

    describe '#tagged?' do
      it 'returns true when team has tags' do
        team.add_tag(tag1)
        expect(team.tagged?).to be true
      end

      it 'returns false when team has no tags' do
        expect(team.tagged?).to be false
      end
    end

    describe '#total_tags' do
      it 'returns the count of tags' do
        team.add_tag(tag1)
        team.add_tag(tag2)
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
      expect(Team.ransackable_associations).to match_array(%w[organization leader users folders team_memberships tags taggings])
    end
  end
end
