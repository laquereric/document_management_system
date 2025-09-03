require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'associations' do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_many(:teams).dependent(:destroy) }
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:tags).through(:taggings) }
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
    let!(:tag1) { create(:tag) }
    let!(:tag2) { create(:tag) }

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
        organization.add_tag(tag1)
        organization.add_tag(tag2)
        expect(organization.total_tags).to eq(2)
      end
    end
  end

  describe 'tagging functionality' do
    let(:organization) { create(:organization) }
    let(:tag1) { create(:tag, name: 'Enterprise') }
    let(:tag2) { create(:tag, name: 'Technology') }
    let(:tag3) { create(:tag, name: 'Finance') }

    describe '#add_tag' do
      it 'adds a tag to the organization' do
        organization.add_tag(tag1)
        expect(organization.tags).to include(tag1)
      end

      it 'does not add duplicate tags' do
        organization.add_tag(tag1)
        organization.add_tag(tag1)
        expect(organization.tags.count).to eq(1)
      end
    end

    describe '#remove_tag' do
      it 'removes a tag from the organization' do
        organization.add_tag(tag1)
        organization.remove_tag(tag1)
        expect(organization.tags).not_to include(tag1)
      end
    end

    describe '#has_tag?' do
      it 'returns true when organization has the tag' do
        organization.add_tag(tag1)
        expect(organization.has_tag?(tag1)).to be true
      end

      it 'returns false when organization does not have the tag' do
        expect(organization.has_tag?(tag1)).to be false
      end
    end

    describe '#tag_names' do
      it 'returns comma-separated tag names' do
        organization.add_tag(tag1)
        organization.add_tag(tag2)
        expect(organization.tag_names).to eq('Enterprise, Technology')
      end

      it 'returns empty string when no tags' do
        expect(organization.tag_names).to eq('')
      end
    end

    describe '#tag_name_array' do
      it 'returns array of tag names' do
        organization.add_tag(tag1)
        organization.add_tag(tag2)
        expect(organization.tag_name_array).to eq(['Enterprise', 'Technology'])
      end

      it 'returns empty array when no tags' do
        expect(organization.tag_name_array).to eq([])
      end
    end

    describe '#tags_by_name' do
      it 'returns tags matching the given names' do
        organization.add_tag(tag1)
        organization.add_tag(tag2)
        organization.add_tag(tag3)
        
        result = organization.tags_by_name('Enterprise', 'Technology')
        expect(result).to include(tag1, tag2)
        expect(result).not_to include(tag3)
      end
    end

    describe '#tags_by_color' do
      it 'returns tags matching the given color' do
        organization.add_tag(tag1)
        organization.add_tag(tag2)
        
        result = organization.tags_by_color(tag1.color)
        expect(result).to include(tag1)
        expect(result).not_to include(tag2)
      end
    end

    describe '#tag_count' do
      it 'returns the count of tags' do
        organization.add_tag(tag1)
        organization.add_tag(tag2)
        expect(organization.tag_count).to eq(2)
      end

      it 'returns 0 when no tags' do
        expect(organization.tag_count).to eq(0)
      end
    end

    describe '#tagged?' do
      it 'returns true when organization has tags' do
        organization.add_tag(tag1)
        expect(organization.tagged?).to be true
      end

      it 'returns false when organization has no tags' do
        expect(organization.tagged?).to be false
      end
    end

    describe '#total_tags' do
      it 'returns the count of tags' do
        organization.add_tag(tag1)
        organization.add_tag(tag2)
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
      expect(Organization.ransackable_associations).to match_array(%w[teams users tags taggings])
    end
  end
end
