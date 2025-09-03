FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Organization #{n}" }
    sequence(:description) { |n| "Description for Organization #{n}" }
  end
end
