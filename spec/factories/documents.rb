FactoryBot.define do
  factory :document do
    sequence(:title) { |n| "Document #{n}" }
    url { "https://example.com/document" }
    sequence(:content) { |n| "Content for Document #{n}" }
    folder
    author { create(:user, organization: folder.team.organization) }
    status
    scenario
  end
end
