# Document list component for displaying multiple documents

class User::DocumentComponents::ListComponent < ApplicationComponent
  LAYOUT_VARIANTS = %i[list grid table].freeze
  SORT_OPTIONS = %i[title created_at updated_at author status].freeze

  def initialize(
    documents: [],
    layout: :list,
    show_filters: true,
    show_sorting: true,
    current_sort: :updated_at,
    search: nil,
    **system_arguments
  )
    @documents = documents
    @layout = fetch_or_fallback(LAYOUT_VARIANTS, layout, :list)
    @show_filters = show_filters
    @show_sorting = show_sorting
    @current_sort = fetch_or_fallback(SORT_OPTIONS, current_sort, :updated_at)
    @search = search
    super(**system_arguments)
  end

  private

  attr_reader :documents, :layout, :show_filters, :show_sorting, :current_sort, :search

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
