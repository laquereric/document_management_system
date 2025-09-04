FactoryBot.define do
  factory :activity do
    sequence(:action) { |n| %w[created updated deleted status_change tagged untagged].sample }
    notes { "Test activity notes" }
    association :document
    association :user
    association :old_status, factory: :status
    association :new_status, factory: :status
  end
end
