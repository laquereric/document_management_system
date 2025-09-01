class User::Dashboard::RecentDocumentsComponent < ApplicationComponent
  def initialize(documents:, limit: 5, **system_arguments)
    @documents = documents.limit(limit)
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :documents, :system_arguments, :documents_path, :new_document_path

  def card_classes
    "Box #{system_arguments[:class]}"
  end

  def has_documents?
    documents.any?
  end

  # Context methods for the template
  def template_context
    {
      card_classes: card_classes,
      has_documents?: has_documents?,
      documents: documents,
      documents_path: documents_path,
      document_path: method(:document_path),
      new_document_path: new_document_path,
      time_ago_in_words: method(:time_ago_in_words),
      render: method(:render)
    }
  end
end
