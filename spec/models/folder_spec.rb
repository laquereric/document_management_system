require 'rails_helper'

RSpec.describe Folder, type: :model do
  subject { build(:folder) }

  describe 'associations' do
    it { should belong_to(:parent_folder).class_name('Folder').optional }
    it { should belong_to(:team) }
    it { should have_many(:subfolders).class_name('Folder').with_foreign_key('parent_folder_id').dependent(:destroy) }
    it { should have_many(:documents).dependent(:destroy) }
    it { should have_many(:tags).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to([:parent_folder_id, :team_id]).with_message('has already been taken') }
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
    let!(:tag1) { create(:tag, folder: root_folder) }
    let!(:tag2) { create(:tag, folder: subfolder) }

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
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(Folder.ransackable_attributes).to match_array(%w[name description created_at updated_at team_id parent_folder_id])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(Folder.ransackable_associations).to match_array(%w[team parent_folder subfolders documents tags])
    end
  end
end
