FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag #{n}" }
    color { "#007bff" }
    association :organization
  end
end
