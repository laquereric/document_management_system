FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    description { "Test team" }
    association :organization
    association :leader, factory: :user
  end
end
