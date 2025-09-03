require 'rails_helper'

RSpec.describe Tagging, type: :model do
  let(:organization) { create(:organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:user) { create(:user, organization: organization) }
  let(:scenario) { create(:scenario) }
  let(:document) { create(:document, folder: folder, author: user, scenario: scenario) }
  let(:tag) { create(:tag) }

  describe 'associations' do
    it { should belong_to(:taggable) }
    it { should belong_to(:tag) }
  end

  describe 'validations' do
    subject { create(:tagging) }

    it { should validate_uniqueness_of(:tag_id).scoped_to([ :taggable_type, :taggable_id ]) }
  end

  describe 'delegations' do
    let(:tagging) { create(:tagging, taggable: document, tag: tag) }

    it 'delegates organization to taggable' do
      expect(tagging.organization).to eq(document.organization)
    end

    it 'delegates team to taggable' do
      expect(tagging.team).to eq(document.team)
    end

    it 'delegates folder to taggable' do
      expect(tagging.folder).to eq(document.folder)
    end
  end

  describe '#taggable_name' do
    context 'when taggable is a Document' do
      let(:tagging) { create(:tagging, taggable: document, tag: tag) }

      it 'returns the document title' do
        expect(tagging.taggable_name).to eq(document.title)
      end
    end

    context 'when taggable is a Folder' do
      let(:tagging) { create(:tagging, taggable: folder, tag: tag) }

      it 'returns the folder name' do
        expect(tagging.taggable_name).to eq(folder.name)
      end
    end

    context 'when taggable is an Organization' do
      let(:tagging) { create(:tagging, taggable: organization, tag: tag) }

      it 'returns the organization name' do
        expect(tagging.taggable_name).to eq(organization.name)
      end
    end

    context 'when taggable is a Scenario' do
      let(:tagging) { create(:tagging, taggable: scenario, tag: tag) }

      it 'returns the scenario name' do
        expect(tagging.taggable_name).to eq(scenario.name)
      end
    end

    context 'when taggable is a Team' do
      let(:tagging) { create(:tagging, taggable: team, tag: tag) }

      it 'returns the team name' do
        expect(tagging.taggable_name).to eq(team.name)
      end
    end

    context 'when taggable is a User' do
      let(:tagging) { create(:tagging, taggable: user, tag: tag) }

      it 'returns the user name' do
        expect(tagging.taggable_name).to eq(user.name)
      end
    end

    context 'when taggable is nil' do
      let(:tagging) { build(:tagging, taggable: nil, tag: tag) }

      it 'returns "Unknown"' do
        expect(tagging.taggable_name).to eq('Unknown')
      end
    end
  end

  describe '#taggable_class_name' do
    let(:tagging) { create(:tagging, taggable: document, tag: tag) }

    it 'returns the downcased class name' do
      expect(tagging.taggable_class_name).to eq('document')
    end
  end

  describe '#tag_name' do
    let(:tagging) { create(:tagging, taggable: document, tag: tag) }

    it 'returns the tag name' do
      expect(tagging.tag_name).to eq(tag.name)
    end
  end

  describe '#tag_color' do
    let(:tagging) { create(:tagging, taggable: document, tag: tag) }

    it 'returns the tag color' do
      expect(tagging.tag_color).to eq(tag.color)
    end
  end

  describe 'polymorphic associations' do
    it 'can tag a Document' do
      tagging = create(:tagging, taggable: document, tag: tag)
      expect(tagging.taggable).to eq(document)
      expect(tagging.taggable_type).to eq('Document')
    end

    it 'can tag a Folder' do
      tagging = create(:tagging, taggable: folder, tag: tag)
      expect(tagging.taggable).to eq(folder)
      expect(tagging.taggable_type).to eq('Folder')
    end

    it 'can tag an Organization' do
      tagging = create(:tagging, taggable: organization, tag: tag)
      expect(tagging.taggable).to eq(organization)
      expect(tagging.taggable_type).to eq('Organization')
    end

    it 'can tag a Scenario' do
      tagging = create(:tagging, taggable: scenario, tag: tag)
      expect(tagging.taggable).to eq(scenario)
      expect(tagging.taggable_type).to eq('Scenario')
    end

    it 'can tag a Team' do
      tagging = create(:tagging, taggable: team, tag: tag)
      expect(tagging.taggable).to eq(team)
      expect(tagging.taggable_type).to eq('Team')
    end

    it 'can tag a User' do
      tagging = create(:tagging, taggable: user, tag: tag)
      expect(tagging.taggable).to eq(user)
      expect(tagging.taggable_type).to eq('User')
    end
  end

  describe 'uniqueness constraint' do
    it 'prevents duplicate tags on the same taggable' do
      create(:tagging, taggable: document, tag: tag)

      expect {
        create(:tagging, taggable: document, tag: tag)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'allows the same tag on different taggables' do
      create(:tagging, taggable: document, tag: tag)

      expect {
        create(:tagging, taggable: folder, tag: tag)
      }.not_to raise_error
    end

    it 'allows different tags on the same taggable' do
      tag2 = create(:tag)
      create(:tagging, taggable: document, tag: tag)

      expect {
        create(:tagging, taggable: document, tag: tag2)
      }.not_to raise_error
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(Tagging.ransackable_attributes).to match_array(%w[created_at updated_at tag_id taggable_type taggable_id])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(Tagging.ransackable_associations).to match_array(%w[tag taggable])
    end
  end
end
