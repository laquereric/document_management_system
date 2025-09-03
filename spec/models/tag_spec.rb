require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject { build(:tag) }

  describe 'associations' do
    it { should belong_to(:organization).optional }
    it { should belong_to(:team).optional }
    it { should belong_to(:folder).optional }
    it { should have_many(:document_tags).dependent(:destroy) }
    it { should have_many(:documents).through(:document_tags) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:color) }
    it { should validate_uniqueness_of(:name).scoped_to([:organization_id, :team_id, :folder_id]) }
  end

  describe 'scopes' do
    let(:organization) { create(:organization) }
    let(:team) { create(:team, organization: organization) }
    let(:folder) { create(:folder, team: team) }
    let!(:org_tag) { create(:tag, organization: organization) }
    let!(:team_tag) { create(:tag, team: team) }
    let!(:folder_tag) { create(:tag, folder: folder) }
    let!(:global_tag) { create(:tag) }

    describe '.by_organization' do
      it 'returns tags for a specific organization' do
        expect(Tag.by_organization(organization)).to include(org_tag)
        expect(Tag.by_organization(organization)).not_to include(team_tag, folder_tag, global_tag)
      end
    end

    describe '.by_team' do
      it 'returns tags for a specific team' do
        expect(Tag.by_team(team)).to include(team_tag)
        expect(Tag.by_team(team)).not_to include(org_tag, folder_tag, global_tag)
      end
    end

    describe '.by_folder' do
      it 'returns tags for a specific folder' do
        expect(Tag.by_folder(folder)).to include(folder_tag)
        expect(Tag.by_folder(folder)).not_to include(org_tag, team_tag, global_tag)
      end
    end

    describe '.global' do
      it 'returns tags not associated with any specific context' do
        expect(Tag.global).to include(global_tag)
        expect(Tag.global).not_to include(org_tag, team_tag, folder_tag)
      end
    end
  end

  describe 'methods' do
    let(:tag) { create(:tag, name: 'Important', color: '#ff0000') }
    let!(:document1) { create(:document) }
    let!(:document2) { create(:document) }

    before do
      tag.documents << document1
      tag.documents << document2
    end

    describe '#document_count' do
      it 'returns the count of documents with this tag' do
        expect(tag.document_count).to eq(2)
      end
    end

    describe '#css_class' do
      it 'returns a CSS class based on the tag name' do
        expect(tag.css_class).to eq('tag-important')
      end
    end

    describe '#context' do
      it 'returns organization when tag belongs to organization' do
        organization = create(:organization)
        org_tag = create(:tag, organization: organization)
        expect(org_tag.context).to eq('organization')
      end

      it 'returns team when tag belongs to team' do
        team = create(:team)
        team_tag = create(:tag, team: team)
        expect(team_tag.context).to eq('team')
      end

      it 'returns folder when tag belongs to folder' do
        folder = create(:folder)
        folder_tag = create(:tag, folder: folder)
        expect(folder_tag.context).to eq('folder')
      end

      it 'returns global when tag has no specific context' do
        expect(tag.context).to eq('global')
      end
    end

    describe '#context_name' do
      it 'returns organization name when tag belongs to organization' do
        organization = create(:organization, name: 'Acme Corp')
        org_tag = create(:tag, organization: organization)
        expect(org_tag.context_name).to eq('Acme Corp')
      end

      it 'returns team name when tag belongs to team' do
        team = create(:team, name: 'Development Team')
        team_tag = create(:tag, team: team)
        expect(team_tag.context_name).to eq('Development Team')
      end

      it 'returns folder name when tag belongs to folder' do
        folder = create(:folder, name: 'Project Docs')
        folder_tag = create(:tag, folder: folder)
        expect(folder_tag.context_name).to eq('Project Docs')
      end

      it 'returns nil when tag has no specific context' do
        expect(tag.context_name).to be_nil
      end
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(Tag.ransackable_attributes).to match_array(%w[name color created_at updated_at organization_id team_id folder_id id id_value])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(Tag.ransackable_associations).to match_array(%w[organization team folder documents document_tags])
    end
  end
end
