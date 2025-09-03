require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should belong_to(:organization).optional }
    it { should have_many(:team_memberships).dependent(:destroy) }
    it { should have_many(:teams).through(:team_memberships) }
    it { should have_many(:led_teams).class_name('Team').with_foreign_key('leader_id').dependent(:nullify) }
    it { should have_many(:authored_documents).class_name('Document').with_foreign_key('author_id').dependent(:destroy) }
    it { should have_many(:activities).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:role) }
    it { should validate_inclusion_of(:role).in_array(%w[admin team_leader member]) }
  end

  describe 'scopes' do
    let!(:admin_user) { create(:user, :admin) }
    let!(:team_leader_user) { create(:user, :team_leader) }
    let!(:member_user) { create(:user, :member) }

    describe '.admins' do
      it 'returns only admin users' do
        expect(User.admins).to include(admin_user)
        expect(User.admins).not_to include(team_leader_user, member_user)
      end
    end

    describe '.team_leaders' do
      it 'returns only team leader users' do
        expect(User.team_leaders).to include(team_leader_user)
        expect(User.team_leaders).not_to include(admin_user, member_user)
      end
    end

    describe '.members' do
      it 'returns only member users' do
        expect(User.members).to include(member_user)
        expect(User.members).not_to include(admin_user, team_leader_user)
      end
    end
  end

  describe 'methods' do
    let(:user) { create(:user, name: 'John Doe') }

    describe '#full_name' do
      it 'returns the user name' do
        expect(user.full_name).to eq('John Doe')
      end
    end

    describe '#admin?' do
      it 'returns true for admin users' do
        admin_user = create(:user, :admin)
        expect(admin_user.admin?).to be true
      end

      it 'returns false for non-admin users' do
        expect(user.admin?).to be false
      end
    end

    describe '#team_leader?' do
      it 'returns true for team leader users' do
        team_leader_user = create(:user, :team_leader)
        expect(team_leader_user.team_leader?).to be true
      end

      it 'returns false for non-team leader users' do
        expect(user.team_leader?).to be false
      end
    end

    describe '#member?' do
      it 'returns true for member users' do
        expect(user.member?).to be true
      end

      it 'returns false for non-member users' do
        admin_user = create(:user, :admin)
        expect(admin_user.member?).to be false
      end
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(User.ransackable_attributes).to match_array(%w[name email role created_at updated_at organization_id])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(User.ransackable_associations).to match_array(%w[organization teams authored_documents activities team_memberships led_teams])
    end
  end
end
