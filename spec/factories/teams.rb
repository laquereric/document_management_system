FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    description { "Test team" }
    association :organization
  end
end
