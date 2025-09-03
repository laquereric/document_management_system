class Layout::CardList::SearchFilterSort::SearchSectionComponent < ApplicationComponent
  def initialize(
    title: "Search & Filters",
    search_object: nil,
    **system_arguments
  )
    @title = title
    @search_object = search_object
    super(**system_arguments)
  end

  private

  attr_reader :title, :search_object

  # Context methods for the template
  def template_context
    {
      title: title,
      search_object: search_object
    }
  end
end
