FactoryBot.define do
  factory :folder do
    name { "MyString" }
    description { "MyText" }
    parent_folder { nil }
    team { nil }
  end
end
