FactoryBot.define do
  factory :folder do
    sequence(:name) { |n| "Folder #{n}" }
    sequence(:description) { |n| "Description for Folder #{n}" }
    parent_folder { nil }
    team
  end
end
