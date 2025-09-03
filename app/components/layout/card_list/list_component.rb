# Generic card list component for displaying multiple cards of any type

class Layout::CardList::ListComponent < ApplicationComponent
  LAYOUT_VARIANTS = %i[list grid table].freeze
  DEFAULT_SORT_OPTIONS = %i[title created_at updated_at author status].freeze

  def initialize(
    cards: [],
    layout: :list,
    title: "Items",
    show_filters: true,
    show_sorting: true,
    current_sort: :updated_at,
    search: nil,
    sort_options: nil,
    empty_state_title: "No items found",
    empty_state_description: "Get started by creating your first item.",
    empty_state_action: nil,
    card_component: nil,
    **system_arguments
  )
    @cards = cards
    @layout = fetch_or_fallback(LAYOUT_VARIANTS, layout, :list)
    @title = title
    @show_filters = show_filters
    @show_sorting = show_sorting
    @current_sort = fetch_or_fallback(sort_options || DEFAULT_SORT_OPTIONS, current_sort, :updated_at)
    @search = search
    @sort_options = sort_options || DEFAULT_SORT_OPTIONS
    @empty_state_title = empty_state_title
    @empty_state_description = empty_state_description
    @empty_state_action = empty_state_action
    @card_component = card_component
    super(**system_arguments)
  end

  private

  attr_reader :cards, :layout, :title, :show_filters, :show_sorting, :current_sort, :search, 
              :sort_options, :empty_state_title, :empty_state_description, :empty_state_action, :card_component

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

  def sort_options_data
    @sort_options.map do |option|
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

  # Context methods for the template
  def template_context
    {
      container_classes: container_classes,
      sort_options: sort_options_data,
      layout_options: layout_options,
      cards: cards,
      layout: layout,
      title: title,
      show_filters: show_filters,
      show_sorting: show_sorting,
      current_sort: current_sort,
      search: search,
      empty_state_title: empty_state_title,
      empty_state_description: empty_state_description,
      empty_state_action: empty_state_action,
      card_component: card_component,
      render: method(:render),
      render_card: method(:render_card),
      Primer: Primer
    }
  end

  def render_card(card)
    if card_component
      # Use the specified card component
      render(card_component.new(card: card))
    elsif card.respond_to?(:card_component)
      # Card has its own card_component method
      render(card.card_component)
    else
      # Fallback to a simple display
      content_tag(:div, class: "card p-3 border rounded") do
        content_tag(:div, card.to_s, class: "card-title h5")
      end
    end
  end
end
