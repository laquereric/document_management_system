class Search::SearchFormComponent < ApplicationComponent
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
end
