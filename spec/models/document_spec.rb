require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'associations' do
    it { should belong_to(:folder) }
    it { should belong_to(:author).class_name('User') }
    it { should belong_to(:status) }
    it { should belong_to(:scenario) }
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:tags).through(:taggings) }
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

    describe '#tag_names' do
      it 'returns comma-separated tag names' do
        document.add_tag(tag1)
        document.add_tag(tag2)
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

    describe 'tagging functionality' do
      let(:tag1) { create(:tag, name: 'Important') }
      let(:tag2) { create(:tag, name: 'Draft') }
      let(:tag3) { create(:tag, name: 'Review') }

      describe '#add_tag' do
        it 'adds a tag to the document' do
          document.add_tag(tag1)
          expect(document.tags).to include(tag1)
        end

        it 'does not add duplicate tags' do
          document.add_tag(tag1)
          document.add_tag(tag1)
          expect(document.tags.count).to eq(1)
        end
      end

      describe '#remove_tag' do
        it 'removes a tag from the document' do
          document.add_tag(tag1)
          document.remove_tag(tag1)
          expect(document.tags).not_to include(tag1)
        end
      end

      describe '#has_tag?' do
        it 'returns true when document has the tag' do
          document.add_tag(tag1)
          expect(document.has_tag?(tag1)).to be true
        end

        it 'returns false when document does not have the tag' do
          expect(document.has_tag?(tag1)).to be false
        end
      end

      describe '#tag_names' do
        it 'returns comma-separated tag names' do
          document.add_tag(tag1)
          document.add_tag(tag2)
          expect(document.tag_names).to eq('Important, Draft')
        end

        it 'returns empty string when no tags' do
          expect(document.tag_names).to eq('')
        end
      end

      describe '#tag_name_array' do
        it 'returns array of tag names' do
          document.add_tag(tag1)
          document.add_tag(tag2)
          expect(document.tag_name_array).to eq(['Important', 'Draft'])
        end

        it 'returns empty array when no tags' do
          expect(document.tag_name_array).to eq([])
        end
      end

      describe '#tags_by_name' do
        it 'returns tags matching the given names' do
          document.add_tag(tag1)
          document.add_tag(tag2)
          document.add_tag(tag3)
          
          result = document.tags_by_name('Important', 'Draft')
          expect(result).to include(tag1, tag2)
          expect(result).not_to include(tag3)
        end
      end

      describe '#tags_by_color' do
        it 'returns tags matching the given color' do
          document.add_tag(tag1)
          document.add_tag(tag2)
          
          result = document.tags_by_color(tag1.color)
          expect(result).to include(tag1)
          expect(result).not_to include(tag2)
        end
      end

      describe '#tag_count' do
        it 'returns the count of tags' do
          document.add_tag(tag1)
          document.add_tag(tag2)
          expect(document.tag_count).to eq(2)
        end

        it 'returns 0 when no tags' do
          expect(document.tag_count).to eq(0)
        end
      end

      describe '#tagged?' do
        it 'returns true when document has tags' do
          document.add_tag(tag1)
          expect(document.tagged?).to be true
        end

        it 'returns false when document has no tags' do
          expect(document.tagged?).to be false
        end
      end

      describe '#total_tags' do
        it 'returns the count of tags' do
          document.add_tag(tag1)
          document.add_tag(tag2)
          expect(document.total_tags).to eq(2)
        end
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
      expect(Document.ransackable_associations).to match_array(%w[author folder status scenario tags taggings activities])
    end
  end
end
