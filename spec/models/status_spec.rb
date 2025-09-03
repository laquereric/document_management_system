require 'rails_helper'

RSpec.describe Status, type: :model do
  describe 'associations' do
    it { should have_many(:documents).dependent(:nullify) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:color) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'scopes' do
    let!(:active_status) { create(:status, name: 'Active', color: '#28a745') }
    let!(:draft_status) { create(:status, name: 'Draft', color: '#ffc107') }
    let!(:archived_status) { create(:status, name: 'Archived', color: '#6c757d') }

    describe '.active' do
      it 'returns only active statuses' do
        expect(Status.active).to include(active_status)
        expect(Status.active).not_to include(draft_status, archived_status)
      end
    end

    describe '.draft' do
      it 'returns only draft statuses' do
        expect(Status.draft).to include(draft_status)
        expect(Status.draft).not_to include(active_status, archived_status)
      end
    end

    describe '.archived' do
      it 'returns only archived statuses' do
        expect(Status.archived).to include(archived_status)
        expect(Status.archived).not_to include(active_status, draft_status)
      end
    end

    describe '.by_color' do
      it 'returns statuses with the specified color' do
        expect(Status.by_color('#28a745')).to include(active_status)
        expect(Status.by_color('#28a745')).not_to include(draft_status, archived_status)
      end
    end
  end

  describe 'methods' do
    let(:status) { create(:status, name: 'In Review', color: '#17a2b8') }
    let!(:document1) { create(:document, status: status) }
    let!(:document2) { create(:document, status: status) }

    describe '#document_count' do
      it 'returns the count of documents with this status' do
        expect(status.document_count).to eq(2)
      end
    end

    describe '#css_class' do
      it 'returns a CSS class based on the status name' do
        expect(status.css_class).to eq('status-in-review')
      end
    end

    describe '#is_active?' do
      it 'returns true for active statuses' do
        active_status = create(:status, name: 'Active')
        expect(active_status.is_active?).to be true
      end

      it 'returns false for non-active statuses' do
        expect(status.is_active?).to be false
      end
    end

    describe '#is_draft?' do
      it 'returns true for draft statuses' do
        draft_status = create(:status, name: 'Draft')
        expect(draft_status.is_draft?).to be true
      end

      it 'returns false for non-draft statuses' do
        expect(status.is_draft?).to be false
      end
    end

    describe '#is_archived?' do
      it 'returns true for archived statuses' do
        archived_status = create(:status, name: 'Archived')
        expect(archived_status.is_archived?).to be true
      end

      it 'returns false for non-archived statuses' do
        expect(status.is_archived?).to be false
      end
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(Status.ransackable_attributes).to match_array(%w[name color created_at updated_at])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(Status.ransackable_associations).to match_array(%w[documents])
    end
  end
end
