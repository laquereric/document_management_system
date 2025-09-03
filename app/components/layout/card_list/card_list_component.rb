# Generic card list component for displaying multiple cards of any type

class Layout::CardList::CardListComponent < ApplicationComponent
  LAYOUT_VARIANTS = %i[list grid table].freeze

  def initialize(
    cards: [],
    layout: :grid,
    title: "Items",
    empty_state_title: "No items found",
    empty_state_description: "Get started by creating your first item.",
    empty_state_action: nil,
    **system_arguments
  )
    @cards = cards
    @layout = fetch_or_fallback(LAYOUT_VARIANTS, layout, :grid)
    @title = title
    @empty_state_title = empty_state_title
    @empty_state_description = empty_state_description
    @empty_state_action = empty_state_action
    super(**system_arguments)
  end

  private

  attr_reader :cards, :layout, :title, :empty_state_title, :empty_state_description, :empty_state_action

  def container_classes
    case layout
    when :grid
      "d-grid gap-3 grid-template-columns-repeat-auto-fill-minmax-300px-1fr"
    when :table
      "Box"
    else
      "d-flex flex-column gap-3"
    end
  end
end
