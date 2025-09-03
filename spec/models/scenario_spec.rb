require 'rails_helper'

RSpec.describe Scenario, type: :model do
  describe 'associations' do
    it { should have_many(:documents).dependent(:nullify) }
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:tags).through(:taggings) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'scopes' do
    let!(:scenario1) { create(:scenario, created_at: 2.days.ago) }
    let!(:scenario2) { create(:scenario, created_at: 1.day.ago) }
    let!(:scenario3) { create(:scenario, created_at: Time.current) }

    describe '.recent' do
      it 'returns scenarios ordered by creation date descending' do
        expect(Scenario.recent.to_a).to eq([scenario3, scenario2, scenario1])
      end
    end

    describe '.by_name' do
      it 'returns scenarios matching the name pattern' do
        expect(Scenario.by_name('Scenario')).to include(scenario1, scenario2, scenario3)
      end
    end
  end

  describe 'methods' do
    let(:scenario) { create(:scenario, name: 'Test Scenario', description: 'A test scenario') }
    let!(:document1) { create(:document, scenario: scenario) }
    let!(:document2) { create(:document, scenario: scenario) }

    describe '#document_count' do
      it 'returns the count of documents with this scenario' do
        expect(scenario.document_count).to eq(2)
      end
    end

    describe '#display_name' do
      it 'returns the scenario name' do
        expect(scenario.display_name).to eq('Test Scenario')
      end
    end

    describe '#summary' do
      it 'returns the scenario description' do
        expect(scenario.summary).to eq('A test scenario')
      end
    end

    describe '#total_tags' do
      it 'returns the count of tags' do
        expect(scenario.total_tags).to eq(0)
      end
    end
  end

  describe 'tagging functionality' do
    let(:scenario) { create(:scenario) }
    let(:tag1) { create(:tag, name: 'Business') }
    let(:tag2) { create(:tag, name: 'Technical') }
    let(:tag3) { create(:tag, name: 'User Story') }

    describe '#add_tag' do
      it 'adds a tag to the scenario' do
        scenario.add_tag(tag1)
        expect(scenario.tags).to include(tag1)
      end

      it 'does not add duplicate tags' do
        scenario.add_tag(tag1)
        scenario.add_tag(tag1)
        expect(scenario.tags.count).to eq(1)
      end
    end

    describe '#remove_tag' do
      it 'removes a tag from the scenario' do
        scenario.add_tag(tag1)
        scenario.remove_tag(tag1)
        expect(scenario.tags).not_to include(tag1)
      end
    end

    describe '#has_tag?' do
      it 'returns true when scenario has the tag' do
        scenario.add_tag(tag1)
        expect(scenario.has_tag?(tag1)).to be true
      end

      it 'returns false when scenario does not have the tag' do
        expect(scenario.has_tag?(tag1)).to be false
      end
    end

    describe '#tag_names' do
      it 'returns comma-separated tag names' do
        scenario.add_tag(tag1)
        scenario.add_tag(tag2)
        expect(scenario.tag_names).to eq('Business, Technical')
      end

      it 'returns empty string when no tags' do
        expect(scenario.tag_names).to eq('')
      end
    end

    describe '#tag_name_array' do
      it 'returns array of tag names' do
        scenario.add_tag(tag1)
        scenario.add_tag(tag2)
        expect(scenario.tag_name_array).to eq(['Business', 'Technical'])
      end

      it 'returns empty array when no tags' do
        expect(scenario.tag_name_array).to eq([])
      end
    end

    describe '#tags_by_name' do
      it 'returns tags matching the given names' do
        scenario.add_tag(tag1)
        scenario.add_tag(tag2)
        scenario.add_tag(tag3)
        
        result = scenario.tags_by_name('Business', 'Technical')
        expect(result).to include(tag1, tag2)
        expect(result).not_to include(tag3)
      end
    end

    describe '#tags_by_color' do
      it 'returns tags matching the given color' do
        scenario.add_tag(tag1)
        scenario.add_tag(tag2)
        
        result = scenario.tags_by_color(tag1.color)
        expect(result).to include(tag1)
        expect(result).not_to include(tag2)
      end
    end

    describe '#tag_count' do
      it 'returns the count of tags' do
        scenario.add_tag(tag1)
        scenario.add_tag(tag2)
        expect(scenario.tag_count).to eq(2)
      end

      it 'returns 0 when no tags' do
        expect(scenario.tag_count).to eq(0)
      end
    end

    describe '#tagged?' do
      it 'returns true when scenario has tags' do
        scenario.add_tag(tag1)
        expect(scenario.tagged?).to be true
      end

      it 'returns false when scenario has no tags' do
        expect(scenario.tagged?).to be false
      end
    end

    describe '#total_tags' do
      it 'returns the count of tags' do
        scenario.add_tag(tag1)
        scenario.add_tag(tag2)
        expect(scenario.total_tags).to eq(2)
      end
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(Scenario.ransackable_attributes).to match_array(%w[name description created_at updated_at id id_value])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(Scenario.ransackable_associations).to match_array(%w[documents tags taggings])
    end
  end
end
