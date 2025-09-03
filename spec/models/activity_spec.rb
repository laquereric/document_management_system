require 'rails_helper'

RSpec.describe Activity, type: :model do
  subject { build(:activity) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:document) }
    it { should belong_to(:old_status).class_name('Status').optional }
    it { should belong_to(:new_status).class_name('Status').optional }
  end

  describe 'validations' do
    it { should belong_to(:user) }
    it { should belong_to(:document) }
    it { should validate_presence_of(:action) }
    it { should validate_inclusion_of(:action).in_array(%w[created updated deleted status_change tagged untagged]) }
  end

  describe 'scopes' do
    let!(:activity1) { create(:activity, created_at: 2.days.ago) }
    let!(:activity2) { create(:activity, created_at: 1.day.ago) }
    let!(:activity3) { create(:activity, created_at: Time.current) }

    describe '.recent' do
      it 'returns activities ordered by creation date descending' do
        expect(Activity.recent.to_a).to eq([activity3, activity2, activity1])
      end
    end

    describe '.by_user' do
      let(:user) { create(:user) }
      let!(:user_activity) { create(:activity, user: user) }

      it 'returns activities for a specific user' do
        expect(Activity.by_user(user)).to include(user_activity)
      end
    end

    describe '.by_document' do
      let(:document) { create(:document) }
      let!(:document_activity) { create(:activity, document: document) }

      it 'returns activities for a specific document' do
        expect(Activity.by_document(document)).to include(document_activity)
      end
    end

    describe '.by_action' do
      let!(:status_change_activity) { create(:activity, action: 'status_change') }

      it 'returns activities with the specified action' do
        expect(Activity.by_action('status_change')).to include(status_change_activity)
      end
    end

    describe '.status_changes' do
      let!(:status_change_activity) { create(:activity, action: 'status_change') }
      let!(:other_activity) { create(:activity, action: 'created') }

      it 'returns only status change activities' do
        expect(Activity.status_changes).to include(status_change_activity)
        expect(Activity.status_changes).not_to include(other_activity)
      end
    end
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let(:document) { create(:document) }
    let(:old_status) { create(:status, name: 'Draft') }
    let(:new_status) { create(:status, name: 'Active') }
    let(:activity) { create(:activity, user: user, document: document, action: 'status_change', old_status: old_status, new_status: new_status) }

    describe '#description' do
      it 'returns a human-readable description of the activity' do
        expect(activity.description).to include('changed status from Draft to Active')
      end
    end

    describe '#action_verb' do
      it 'returns the action verb for created action' do
        created_activity = create(:activity, action: 'created')
        expect(created_activity.action_verb).to eq('created')
      end

      it 'returns the action verb for updated action' do
        updated_activity = create(:activity, action: 'updated')
        expect(updated_activity.action_verb).to eq('updated')
      end

      it 'returns the action verb for deleted action' do
        deleted_activity = create(:activity, action: 'deleted')
        expect(deleted_activity.action_verb).to eq('deleted')
      end

      it 'returns the action verb for status_change action' do
        expect(activity.action_verb).to eq('changed status')
      end

      it 'returns the action verb for tagged action' do
        tagged_activity = create(:activity, action: 'tagged')
        expect(tagged_activity.action_verb).to eq('tagged')
      end

      it 'returns the action verb for untagged action' do
        untagged_activity = create(:activity, action: 'untagged')
        expect(untagged_activity.action_verb).to eq('removed tag')
      end
    end

    describe '#status_change_description' do
      it 'returns description for status change with both old and new status' do
        expect(activity.status_change_description).to eq('from Draft to Active')
      end

      it 'returns description for status change with only new status' do
        status_activity = create(:activity, action: 'status_change', new_status: new_status)
        expect(status_activity.status_change_description).to eq('to Active')
      end

      it 'returns description for status change with only old status' do
        status_activity = create(:activity, action: 'status_change', old_status: old_status)
        expect(status_activity.status_change_description).to eq('from Draft')
      end

      it 'returns nil for non-status change activities' do
        other_activity = create(:activity, action: 'created')
        expect(other_activity.status_change_description).to be_nil
      end
    end

    describe '#document_title' do
      it 'returns the document title' do
        expect(activity.document_title).to eq(document.title)
      end
    end

    describe '#user_name' do
      it 'returns the user name' do
        expect(activity.user_name).to eq(user.name)
      end
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(Activity.ransackable_attributes).to match_array(%w[action created_at updated_at user_id document_id old_status_id new_status_id notes])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(Activity.ransackable_associations).to match_array(%w[user document old_status new_status])
    end
  end
end
