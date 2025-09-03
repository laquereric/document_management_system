FactoryBot.define do
  factory :status do
    sequence(:name) { |n| "Status #{n}" }
    sequence(:description) { |n| "Description for Status #{n}" }
    sequence(:color) { |n| "##{n.to_s(16).rjust(6, '0')}" }
  end
end
