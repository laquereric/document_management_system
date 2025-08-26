FactoryBot.define do
  factory :activity_log do
    document { nil }
    user { nil }
    action { "MyString" }
    old_status { nil }
    new_status { nil }
    notes { "MyText" }
  end
end
