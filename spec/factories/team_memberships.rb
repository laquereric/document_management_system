FactoryBot.define do
  factory :team_membership do
    association :team
    association :user
    joined_at { Time.current }
  end
end
