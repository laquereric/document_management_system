FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { 'member' }
    
    association :organization

    trait :admin do
      role { 'admin' }
    end

    trait :team_leader do
      role { 'team_leader' }
    end

    trait :member do
      role { 'member' }
    end
  end
end
