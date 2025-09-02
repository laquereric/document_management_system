# Card list component for displaying multiple cards (documents, tags, organizations, etc.)

class Layout::CardList < ApplicationComponent
  LAYOUT_VARIANTS = %i[list grid table].freeze
  SORT_OPTIONS = %i[title created_at updated_at author status name].freeze

  def initialize(
    cards: [],
    layout: :grid,
    show_filters: false,
    show_sorting: false,
    current_sort: :updated_at,
    search: nil,
    title: "Items",
    empty_state_title: "No items found",
    empty_state_description: "Get started by creating your first item.",
    empty_state_action: nil,
    **system_arguments
  )
    @cards = cards
    @layout = fetch_or_fallback(LAYOUT_VARIANTS, layout, :grid)
    @show_filters = show_filters
    @show_sorting = show_sorting
    @current_sort = fetch_or_fallback(SORT_OPTIONS, current_sort, :updated_at)
    @search = search
    @title = title
    @empty_state_title = empty_state_title
    @empty_state_description = empty_state_description
    @empty_state_action = empty_state_action
    super(**system_arguments)
  end

  private

  attr_reader :cards, :layout, :show_filters, :show_sorting, :current_sort, :search, 
              :title, :empty_state_title, :empty_state_description, :empty_state_action

  def container_classes
    case layout
    when :grid
      "d-grid gap-3 grid-template-columns-repeat-auto-fill-minmax-300px-1fr"
    when :table
      ""
    else
      "d-flex flex-column gap-3"
    end
  end

  def sort_options
    SORT_OPTIONS.map do |option|
      {
        label: option.to_s.humanize,
        value: option,
        selected: option == current_sort
      }
    end
  end

  def layout_options
    [
      { icon: :file, value: :list, active: layout == :list, label: "List" },
      { icon: :apps, value: :grid, active: layout == :grid, label: "Grid" },
      { icon: :table, value: :table, active: layout == :table, label: "Table" }
    ]
  end
end
