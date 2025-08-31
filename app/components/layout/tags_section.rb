class Layout::TagsSection < ApplicationComponent

  def initialize(
    tags:,
    title: "All Tags",
    show_sorting: false,
    sorting_options: [],
    current_sort: nil,
    **system_arguments
  )
    @tags = tags
    @title = title
    @show_sorting = show_sorting
    @sorting_options = sorting_options
    @current_sort = current_sort
    super(**system_arguments)
  end

  private

  attr_reader :tags, :title, :show_sorting, :sorting_options, :current_sort

  def container_classes
    "mt-5"
  end

  def header_classes
    "d-flex flex-items-center flex-justify-between mb-3"
  end

  def title_classes
    "f4 text-semibold"
  end

  def counter_classes
    "Counter"
  end

  def sorting_container_classes
    "d-flex flex-items-center gap-2"
  end

  def select_classes
    "Select"
  end

  def form_select_classes
    "form-select"
  end

  def box_classes
    "Box"
  end

  def box_body_classes
    "Box-body"
  end

  def cards_container_classes
    "d-flex flex-wrap gap-3"
  end

  def card_container_classes
    "flex-auto"
  end

  def card_styles
    "min-width: 320px; max-width: 400px;"
  end

  def tags_count
    if tags.respond_to?(:total_count)
      tags.total_count
    else
      tags.count
    end
  end

  def render_sorting?
    show_sorting && sorting_options.any?
  end

  def render?
    tags.present?
  end
end
