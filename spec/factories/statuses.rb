FactoryBot.define do
  factory :status do
    sequence(:name) { |n| "Status #{n}" }
    color { "#000000" }
  end
end
