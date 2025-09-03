FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    sequence(:description) { |n| "Description for Team #{n}" }
    organization
    leader { create(:user, organization: organization) }
  end
end
