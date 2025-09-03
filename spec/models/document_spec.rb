require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'associations' do
    it { should belong_to(:folder) }
    it { should belong_to(:author).class_name('User') }
    it { should belong_to(:status) }
    it { should belong_to(:scenario) }
    it { should have_many(:document_tags).dependent(:destroy) }
    it { should have_many(:tags).through(:document_tags) }
    it { should have_many(:activities).dependent(:destroy) }
    it { should have_one_attached(:file) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end

  describe 'scopes' do
    let!(:document1) { create(:document, created_at: 2.days.ago) }
    let!(:document2) { create(:document, created_at: 1.day.ago) }
    let!(:document3) { create(:document, created_at: Time.current) }

    describe '.recent' do
      it 'returns documents ordered by creation date descending' do
        expect(Document.recent.to_a).to eq([document3, document2, document1])
      end
    end

    describe '.by_status' do
      let(:status) { create(:status) }
      let!(:document_with_status) { create(:document, status: status) }

      it 'returns documents with the specified status' do
        expect(Document.by_status(status)).to include(document_with_status)
      end
    end

    describe '.by_author' do
      let(:author) { create(:user) }
      let!(:document_by_author) { create(:document, author: author) }

      it 'returns documents by the specified author' do
        expect(Document.by_author(author)).to include(document_by_author)
      end
    end

    describe '.by_folder' do
      let(:folder) { create(:folder) }
      let!(:document_in_folder) { create(:document, folder: folder) }

      it 'returns documents in the specified folder' do
        expect(Document.by_folder(folder)).to include(document_in_folder)
      end
    end
  end

  describe 'methods' do
    let(:document) { create(:document) }
    let!(:tag1) { create(:tag, name: 'Important') }
    let!(:tag2) { create(:tag, name: 'Draft') }

    before do
      document.tags << tag1
      document.tags << tag2
    end

    describe '#tag_names' do
      it 'returns comma-separated tag names' do
        expect(document.tag_names).to eq('Important, Draft')
      end
    end

    describe '#team' do
      it 'returns the team through the folder' do
        expect(document.team).to eq(document.folder.team)
      end
    end

    describe '#organization' do
      it 'returns the organization through the team' do
        expect(document.organization).to eq(document.folder.team.organization)
      end
    end

    describe '#has_file?' do
      it 'returns true when file is attached' do
        # Mock file attachment
        allow(document).to receive(:file).and_return(double('file', attached?: true, present?: true))
        expect(document.has_file?).to be true
      end

      it 'returns false when no file is attached' do
        allow(document).to receive(:file).and_return(double('file', attached?: false, present?: false))
        expect(document.has_file?).to be false
      end
    end

    describe '#file_extension' do
      it 'returns the file extension when file is attached' do
        allow(document).to receive(:file).and_return(double('file', attached?: true, present?: true, filename: double('filename', to_s: 'document.pdf')))
        expect(document.file_extension).to eq('PDF')
      end

      it 'returns nil when no file is attached' do
        allow(document).to receive(:file).and_return(double('file', attached?: false, present?: false))
        expect(document.file_extension).to be_nil
      end
    end

    describe '#file_icon' do
      it 'returns appropriate icon for PDF files' do
        allow(document).to receive(:file_extension).and_return('PDF')
        expect(document.file_icon).to eq('file-pdf')
      end

      it 'returns appropriate icon for Word documents' do
        allow(document).to receive(:file_extension).and_return('DOCX')
        expect(document.file_icon).to eq('file-word')
      end

      it 'returns appropriate icon for Excel files' do
        allow(document).to receive(:file_extension).and_return('XLSX')
        expect(document.file_icon).to eq('file-spreadsheet')
      end

      it 'returns appropriate icon for PowerPoint files' do
        allow(document).to receive(:file_extension).and_return('PPTX')
        expect(document.file_icon).to eq('file-presentation')
      end

      it 'returns appropriate icon for text files' do
        allow(document).to receive(:file_extension).and_return('TXT')
        expect(document.file_icon).to eq('file-text')
      end

      it 'returns default file icon for unknown extensions' do
        allow(document).to receive(:file_extension).and_return('UNKNOWN')
        expect(document.file_icon).to eq('file')
      end
    end
  end

  describe 'callbacks' do
    let(:document) { create(:document) }
    let(:old_status) { create(:status) }
    let(:new_status) { create(:status) }

    describe 'after_update :log_status_change' do
      it 'creates an activity when status changes' do
        old_status_id = document.status_id
        document.update(status: new_status)
        
        activity = Activity.last
        expect(activity).to be_present
        expect(activity.document).to eq(document)
        expect(activity.action).to eq('status_change')
        expect(activity.old_status_id).to eq(old_status_id)
        expect(activity.new_status_id).to eq(new_status.id)
      end

      it 'does not create activity when status does not change' do
        expect {
          document.update(title: 'Updated Title')
        }.not_to change(Activity, :count)
      end
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(Document.ransackable_attributes).to match_array(%w[title content created_at updated_at author_id folder_id status_id scenario_id])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(Document.ransackable_associations).to match_array(%w[author folder status scenario tags document_tags activities])
    end
  end
end
