FactoryBot.define do
  factory :folder do
    sequence(:name) { |n| "Folder #{n}" }
    description { "Test folder" }
    association :team
  end
end
