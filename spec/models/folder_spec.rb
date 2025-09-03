require 'rails_helper'

RSpec.describe Folder, type: :model do
  subject { build(:folder) }

  describe 'associations' do
    it { should belong_to(:parent_folder).class_name('Folder').optional }
    it { should belong_to(:team) }
    it { should have_many(:subfolders).class_name('Folder').with_foreign_key('parent_folder_id').dependent(:destroy) }
    it { should have_many(:documents).dependent(:destroy) }
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:tags).through(:taggings) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to([ :parent_folder_id, :team_id ]).with_message('has already been taken') }
  end

  describe 'scopes' do
    let(:team) { create(:team) }
    let!(:root_folder) { create(:folder, team: team, parent_folder: nil) }
    let!(:subfolder) { create(:folder, team: team, parent_folder: root_folder) }

    describe '.root_folders' do
      it 'returns only folders without parent folders' do
        expect(Folder.root_folders).to include(root_folder)
        expect(Folder.root_folders).not_to include(subfolder)
      end
    end

    describe '.by_team' do
      it 'returns folders for a specific team' do
        other_team = create(:team)
        other_folder = create(:folder, team: other_team)

        expect(Folder.by_team(team)).to include(root_folder, subfolder)
        expect(Folder.by_team(team)).not_to include(other_folder)
      end
    end
  end

  describe 'methods' do
    let(:team) { create(:team) }
    let(:root_folder) { create(:folder, team: team, name: 'Projects') }
    let(:subfolder) { create(:folder, team: team, parent_folder: root_folder, name: 'Web Development') }
    let(:nested_folder) { create(:folder, team: team, parent_folder: subfolder, name: 'Documentation') }
    let!(:document1) { create(:document, folder: root_folder) }
    let!(:document2) { create(:document, folder: subfolder) }
    let!(:document3) { create(:document, folder: nested_folder) }
    let!(:tag1) { create(:tag) }
    let!(:tag2) { create(:tag) }

    describe '#root?' do
      it 'returns true for folders without parent' do
        expect(root_folder.root?).to be true
      end

      it 'returns false for folders with parent' do
        expect(subfolder.root?).to be false
        expect(nested_folder.root?).to be false
      end
    end

    describe '#path' do
      it 'returns just the name for root folders' do
        expect(root_folder.path).to eq('Projects')
      end

      it 'returns the full path for nested folders' do
        expect(subfolder.path).to eq('Projects / Web Development')
        expect(nested_folder.path).to eq('Projects / Web Development / Documentation')
      end
    end

    describe '#total_documents' do
      it 'returns the count of documents in this folder and all subfolders' do
        expect(root_folder.total_documents).to eq(3)
        expect(subfolder.total_documents).to eq(2)
        expect(nested_folder.total_documents).to eq(1)
      end
    end

    describe '#total_tags' do
      it 'returns the count of tags in this folder' do
        root_folder.add_tag(tag1)
        subfolder.add_tag(tag2)
        expect(root_folder.total_tags).to eq(1)
        expect(subfolder.total_tags).to eq(1)
        expect(nested_folder.total_tags).to eq(0)
      end
    end

    describe '#organization' do
      it 'returns the organization through the team' do
        expect(root_folder.organization).to eq(team.organization)
      end
    end

    describe 'tagging functionality' do
      let(:tag1) { create(:tag, name: 'Project') }
      let(:tag2) { create(:tag, name: 'Development') }
      let(:tag3) { create(:tag, name: 'Documentation') }

      describe '#add_tag' do
        it 'adds a tag to the folder' do
          root_folder.add_tag(tag1)
          expect(root_folder.tags).to include(tag1)
        end

        it 'does not add duplicate tags' do
          root_folder.add_tag(tag1)
          root_folder.add_tag(tag1)
          expect(root_folder.tags.count).to eq(1)
        end
      end

      describe '#remove_tag' do
        it 'removes a tag from the folder' do
          root_folder.add_tag(tag1)
          root_folder.remove_tag(tag1)
          expect(root_folder.tags).not_to include(tag1)
        end
      end

      describe '#has_tag?' do
        it 'returns true when folder has the tag' do
          root_folder.add_tag(tag1)
          expect(root_folder.has_tag?(tag1)).to be true
        end

        it 'returns false when folder does not have the tag' do
          expect(root_folder.has_tag?(tag1)).to be false
        end
      end

      describe '#tag_names' do
        it 'returns comma-separated tag names' do
          root_folder.add_tag(tag1)
          root_folder.add_tag(tag2)
          expect(root_folder.tag_names).to eq('Project, Development')
        end

        it 'returns empty string when no tags' do
          expect(root_folder.tag_names).to eq('')
        end
      end

      describe '#tag_name_array' do
        it 'returns array of tag names' do
          root_folder.add_tag(tag1)
          root_folder.add_tag(tag2)
          expect(root_folder.tag_name_array).to eq([ 'Project', 'Development' ])
        end

        it 'returns empty array when no tags' do
          expect(root_folder.tag_name_array).to eq([])
        end
      end

      describe '#tags_by_name' do
        it 'returns tags matching the given names' do
          root_folder.add_tag(tag1)
          root_folder.add_tag(tag2)
          root_folder.add_tag(tag3)

          result = root_folder.tags_by_name('Project', 'Development')
          expect(result).to include(tag1, tag2)
          expect(result).not_to include(tag3)
        end
      end

      describe '#tags_by_color' do
        it 'returns tags matching the given color' do
          root_folder.add_tag(tag1)
          root_folder.add_tag(tag2)

          result = root_folder.tags_by_color(tag1.color)
          expect(result).to include(tag1)
          expect(result).not_to include(tag2)
        end
      end

      describe '#tag_count' do
        it 'returns the count of tags' do
          root_folder.add_tag(tag1)
          root_folder.add_tag(tag2)
          expect(root_folder.tag_count).to eq(2)
        end

        it 'returns 0 when no tags' do
          expect(root_folder.tag_count).to eq(0)
        end
      end

      describe '#tagged?' do
        it 'returns true when folder has tags' do
          root_folder.add_tag(tag1)
          expect(root_folder.tagged?).to be true
        end

        it 'returns false when folder has no tags' do
          expect(root_folder.tagged?).to be false
        end
      end

      describe '#total_tags' do
        it 'returns the count of tags' do
          root_folder.add_tag(tag1)
          root_folder.add_tag(tag2)
          expect(root_folder.total_tags).to eq(2)
        end
      end
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(Folder.ransackable_attributes).to match_array(%w[name description created_at updated_at team_id parent_folder_id])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(Folder.ransackable_associations).to match_array(%w[team parent_folder subfolders documents tags taggings])
    end
  end
end
