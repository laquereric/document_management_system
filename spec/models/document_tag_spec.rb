git add .require 'rails_helper'

RSpec.describe DocumentTag, type: :model do
  subject { create(:document_tag) }

  describe 'associations' do
    it { should belong_to(:document) }
    it { should belong_to(:tag) }
  end

  describe 'validations' do
    it { should belong_to(:document) }
    it { should belong_to(:tag) }
    it { should validate_uniqueness_of(:document_id).scoped_to(:tag_id) }
  end

  describe 'methods' do
    let(:organization) { create(:organization) }
    let(:team) { create(:team, organization: organization) }
    let(:folder) { create(:folder, team: team) }
    let(:document) { create(:document, folder: folder) }
    let(:tag) { create(:tag, name: 'Important', color: '#ff0000') }
    let(:document_tag) { create(:document_tag, document: document, tag: tag) }

    describe '#organization' do
      it 'returns the organization through the document' do
        expect(document_tag.organization).to eq(organization)
      end
    end

    describe '#team' do
      it 'returns the team through the document' do
        expect(document_tag.team).to eq(team)
      end
    end

    describe '#folder' do
      it 'returns the folder through the document' do
        expect(document_tag.folder).to eq(folder)
      end
    end

    describe '#tag_name' do
      it 'returns the tag name' do
        expect(document_tag.tag_name).to eq('Important')
      end
    end

    describe '#tag_color' do
      it 'returns the tag color' do
        expect(document_tag.tag_color).to eq('#ff0000')
      end
    end

    describe '#document_title' do
      it 'returns the document title' do
        expect(document_tag.document_title).to eq(document.title)
      end
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(DocumentTag.ransackable_attributes).to match_array(%w[created_at updated_at document_id tag_id])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(DocumentTag.ransackable_associations).to match_array(%w[document tag])
    end
  end
end
