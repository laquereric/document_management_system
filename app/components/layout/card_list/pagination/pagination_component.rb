class Layout::CardList::Pagination::PaginationComponent < ApplicationComponent
  def initialize(collection:, **system_arguments)
    @collection = collection
    super(**system_arguments)
  end

  private

  attr_reader :collection

  def render?
    collection.respond_to?(:current_page) && collection.total_pages > 1
  end

  def pagination_options
    {
      theme: "bootstrap",
      window: 2,
      left: 1,
      right: 1,
      gap: true
    }
  end
end
