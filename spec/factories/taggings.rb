FactoryBot.define do
  factory :tagging do
    tag
    taggable { create(:document) }
  end

  # Factory for tagging documents
  factory :document_tagging, class: 'Tagging' do
    tag
    taggable { create(:document) }
  end

  # Factory for tagging folders
  factory :folder_tagging, class: 'Tagging' do
    tag
    taggable { create(:folder) }
  end

  # Factory for tagging organizations
  factory :organization_tagging, class: 'Tagging' do
    tag
    taggable { create(:organization) }
  end

  # Factory for tagging scenarios
  factory :scenario_tagging, class: 'Tagging' do
    tag
    taggable { create(:scenario) }
  end

  # Factory for tagging teams
  factory :team_tagging, class: 'Tagging' do
    tag
    taggable { create(:team) }
  end

  # Factory for tagging users
  factory :user_tagging, class: 'Tagging' do
    tag
    taggable { create(:user) }
  end
end
