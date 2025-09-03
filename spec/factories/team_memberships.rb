FactoryBot.define do
  factory :team_membership do
    team
    user { create(:user, organization: team.organization) }
  end
end
