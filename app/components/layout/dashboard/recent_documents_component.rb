class Layout::Dashboard::RecentDocumentsComponent < ApplicationComponent
  def initialize(documents:, title: "Recent Documents", view_all_path: nil, view_all_text: "View All Documents", new_document_path: nil, limit: 5, **system_arguments)
    @documents = documents.respond_to?(:limit) ? documents.limit(limit) : documents.first(limit)
    @title = title
    @view_all_path = view_all_path
    @view_all_text = view_all_text
    @new_document_path = new_document_path
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :documents, :title, :view_all_path, :view_all_text, :new_document_path, :system_arguments

  def card_classes
    "Box #{system_arguments[:class]}"
  end

  def has_documents?
    documents.any?
  end

  def show_view_all_link?
    view_all_path.present?
  end

  def show_new_document_link?
    new_document_path.present?
  end

  # Context methods for the template
  def template_context
    {
      card_classes: card_classes,
      has_documents?: has_documents?,
      documents: documents,
      title: title,
      view_all_path: view_all_path,
      view_all_text: view_all_text,
      new_document_path: new_document_path,
      show_view_all_link?: show_view_all_link?,
      show_new_document_link?: show_new_document_link?,
      document_path: method(:document_path),
      time_ago_in_words: method(:time_ago_in_words),
      render: method(:render)
    }
  end
end
