require 'rails_helper'

RSpec.describe Taggable, type: :model do
  # Use a real model that includes the Taggable concern
  let(:organization) { create(:organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:user) { create(:user, organization: organization) }
  let(:scenario) { create(:scenario) }
  let(:document) { create(:document, folder: folder, author: user, scenario: scenario) }
  let(:tag) { create(:tag) }

  describe 'associations' do
    it 'has many taggings' do
      expect(organization).to respond_to(:taggings)
    end

    it 'has many tags through taggings' do
      expect(organization).to respond_to(:tags)
    end
  end

  describe '#add_tag' do
    it 'adds a tag to the taggable' do
      organization.add_tag(tag)
      expect(organization.tags).to include(tag)
    end

    it 'does not add duplicate tags' do
      organization.add_tag(tag)
      organization.add_tag(tag)
      expect(organization.tags.count).to eq(1)
    end
  end

  describe '#remove_tag' do
    it 'removes a tag from the taggable' do
      organization.add_tag(tag)
      organization.remove_tag(tag)
      expect(organization.tags).not_to include(tag)
    end
  end

  describe '#has_tag?' do
    it 'returns true when taggable has the tag' do
      organization.add_tag(tag)
      expect(organization.has_tag?(tag)).to be true
    end

    it 'returns false when taggable does not have the tag' do
      expect(organization.has_tag?(tag)).to be false
    end
  end

  describe '#tag_names' do
    it 'returns comma-separated tag names' do
      tag1 = create(:tag, name: 'Tag1')
      tag2 = create(:tag, name: 'Tag2')
      organization.add_tag(tag1)
      organization.add_tag(tag2)
      expect(organization.tag_names).to eq('Tag1, Tag2')
    end

    it 'returns empty string when no tags' do
      expect(organization.tag_names).to eq('')
    end
  end

  describe '#tag_name_array' do
    it 'returns array of tag names' do
      tag1 = create(:tag, name: 'Tag1')
      tag2 = create(:tag, name: 'Tag2')
      organization.add_tag(tag1)
      organization.add_tag(tag2)
      expect(organization.tag_name_array).to eq([ 'Tag1', 'Tag2' ])
    end

    it 'returns empty array when no tags' do
      expect(organization.tag_name_array).to eq([])
    end
  end

  describe '#tags_by_name' do
    it 'returns tags matching the given names' do
      tag1 = create(:tag, name: 'Tag1')
      tag2 = create(:tag, name: 'Tag2')
      tag3 = create(:tag, name: 'Tag3')
      organization.add_tag(tag1)
      organization.add_tag(tag2)
      organization.add_tag(tag3)

      result = organization.tags_by_name('Tag1', 'Tag2')
      expect(result).to include(tag1, tag2)
      expect(result).not_to include(tag3)
    end
  end

  describe '#tags_by_color' do
    it 'returns tags matching the given color' do
      tag1 = create(:tag, color: '#FF0000')
      tag2 = create(:tag, color: '#00FF00')
      organization.add_tag(tag1)
      organization.add_tag(tag2)

      result = organization.tags_by_color('#FF0000')
      expect(result).to include(tag1)
      expect(result).not_to include(tag2)
    end
  end

  describe '#tag_count' do
    it 'returns the count of tags' do
      tag1 = create(:tag)
      tag2 = create(:tag)
      organization.add_tag(tag1)
      organization.add_tag(tag2)
      expect(organization.tag_count).to eq(2)
    end

    it 'returns 0 when no tags' do
      expect(organization.tag_count).to eq(0)
    end
  end

  describe '#tagged?' do
    it 'returns true when taggable has tags' do
      organization.add_tag(tag)
      expect(organization.tagged?).to be true
    end

    it 'returns false when taggable has no tags' do
      expect(organization.tagged?).to be false
    end
  end

  # Note: tags_in_context method is complex and context-dependent
  # It's tested in the individual model specs where the context makes more sense
end
