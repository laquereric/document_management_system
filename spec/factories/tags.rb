FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag #{n}" }
    sequence(:color) { |n| "##{n.to_s(16).rjust(6, '0')}" }
  end
end
