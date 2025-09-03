require 'rails_helper'

RSpec.describe TeamMembership, type: :model do
  subject { build(:team_membership) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:team) }
  end

  describe 'validations' do
    it { should belong_to(:user) }
    it { should belong_to(:team) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:team_id) }
  end

  describe 'scopes' do
    let(:organization) { create(:organization) }
    let(:team1) { create(:team, organization: organization) }
    let(:team2) { create(:team, organization: organization) }
    let(:user) { create(:user, organization: organization) }
    let!(:membership1) { create(:team_membership, user: user, team: team1) }
    let!(:membership2) { create(:team_membership, user: user, team: team2) }

    describe '.by_user' do
      it 'returns memberships for a specific user' do
        expect(TeamMembership.by_user(user)).to include(membership1, membership2)
      end
    end

    describe '.by_team' do
      it 'returns memberships for a specific team' do
        expect(TeamMembership.by_team(team1)).to include(membership1)
        expect(TeamMembership.by_team(team1)).not_to include(membership2)
      end
    end

    describe '.by_organization' do
      it 'returns memberships for a specific organization' do
        other_org = create(:organization)
        other_team = create(:team, organization: other_org)
        other_membership = create(:team_membership, user: user, team: other_team)
        
        expect(TeamMembership.by_organization(organization)).to include(membership1, membership2)
        expect(TeamMembership.by_organization(organization)).not_to include(other_membership)
      end
    end
  end

  describe 'methods' do
    let(:organization) { create(:organization) }
    let(:team) { create(:team, organization: organization) }
    let(:user) { create(:user, organization: organization) }
    let(:membership) { create(:team_membership, user: user, team: team) }

    describe '#organization' do
      it 'returns the organization through the team' do
        expect(membership.organization).to eq(organization)
      end
    end

    describe '#user_name' do
      it 'returns the user name' do
        expect(membership.user_name).to eq(user.name)
      end
    end

    describe '#team_name' do
      it 'returns the team name' do
        expect(membership.team_name).to eq(team.name)
      end
    end
  end

  describe 'ransackable attributes' do
    it 'includes the correct attributes' do
      expect(TeamMembership.ransackable_attributes).to match_array(%w[created_at updated_at user_id team_id joined_at])
    end
  end

  describe 'ransackable associations' do
    it 'includes the correct associations' do
      expect(TeamMembership.ransackable_associations).to match_array(%w[user team])
    end
  end
end
