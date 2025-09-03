FactoryBot.define do
  factory :scenario do
    sequence(:name) { |n| "Scenario #{n}" }
    sequence(:description) { |n| "Description for Scenario #{n}" }
  end
end
