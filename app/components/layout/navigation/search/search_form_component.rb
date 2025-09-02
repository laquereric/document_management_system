class Layout::Navigation::Search::SearchFormComponent < ApplicationComponent
  def initialize(q: nil, **system_arguments)
    @q = q
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :q, :system_arguments

  def form_classes
    "search-form #{system_arguments[:class]}"
  end

  def search_placeholder
    "Search documents by title, content, author..."
  end

  # Context methods for the template
  def template_context
    {
      form_classes: form_classes,
      search_placeholder: search_placeholder,
      q: q,
      helpers: helpers,
      search_form_for: method(:search_form_for),
      search_path: search_path,
      documents_path: documents_path,
      options_from_collection_for_select: method(:options_from_collection_for_select),
      Status: defined?(Status) ? Status : nil,
      User: defined?(User) ? User : nil,
      Folder: defined?(Folder) ? Folder : nil,
      link_to: method(:link_to)
    }
  end
end
