FactoryBot.define do
  factory :scenario do
    sequence(:name) { |n| "Scenario #{n}" }
    description { "Test scenario" }
  end
end
