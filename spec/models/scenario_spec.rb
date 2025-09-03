require 'rails_helper'

RSpec.describe Scenario, type: :model do
  describe 'associations' do
    it { should have_many(:documents).dependent(:nullify) }
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
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(Scenario.ransackable_attributes).to match_array(%w[name description created_at updated_at id id_value])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(Scenario.ransackable_associations).to match_array(%w[documents])
    end
  end
end
