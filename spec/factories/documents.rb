FactoryBot.define do
  factory :document do
    sequence(:title) { |n| "Document #{n}" }
    content { "This is the content of the test document." }
    association :folder
    association :author, factory: :user
    association :status
    association :scenario
  end
end
