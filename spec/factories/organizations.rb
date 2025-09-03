FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Organization #{n}" }
    description { "Test organization" }
  end
end
