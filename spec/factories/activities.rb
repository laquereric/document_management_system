FactoryBot.define do
  factory :activity do
    action { 'created' }
    document
    user { document.author }
    old_status { nil }
    new_status { nil }
    notes { nil }
  end
end
