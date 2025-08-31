class Layout::CardListPagination < ApplicationComponent

  def initialize(collection:, **system_arguments)
    @collection = collection
    super(**system_arguments)
  end

  private

  attr_reader :collection

  def render?
    collection.respond_to?(:current_page) && collection.total_pages > 1
  end

  def current_page
    collection.current_page
  end

  def total_pages
    collection.total_pages
  end

  def prev_page
    collection.prev_page
  end

  def next_page
    collection.next_page
  end

  def page_numbers
    return [] if total_pages <= 1

    numbers = []
    
    total_pages.times do |page_num|
      page_num += 1
      
      if page_num == current_page
        numbers << { number: page_num, current: true }
      elsif page_num == 1 || page_num == total_pages || 
            (page_num >= current_page - 2 && page_num <= current_page + 2)
        numbers << { number: page_num, current: false }
      elsif page_num == current_page - 3 || page_num == current_page + 3
        numbers << { number: nil, gap: true }
      end
    end
    
    numbers
  end

  def pagination_classes
    "d-flex flex-justify-center mt-4"
  end

  def nav_classes
    "paginate-container"
  end

  def pagination_container_classes
    "pagination"
  end

  def previous_link_classes
    "previous_page"
  end

  def next_link_classes
    "next_page"
  end

  def current_page_classes
    "current"
  end

  def gap_classes
    "gap"
  end
end
