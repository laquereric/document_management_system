class User::Dashboard::RecentDocumentsComponent < ApplicationComponent
  def initialize(documents:, limit: 5, **system_arguments)
    @documents = documents.limit(limit)
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :documents, :system_arguments

  def card_classes
    "Box #{system_arguments[:class]}"
  end

  def has_documents?
    documents.any?
  end
end
