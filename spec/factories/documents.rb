FactoryBot.define do
  factory :document do
    title { "MyString" }
    url { "MyString" }
    content { "MyText" }
    folder { nil }
    author { nil }
    status { nil }
    scenario_type { nil }
  end
end
