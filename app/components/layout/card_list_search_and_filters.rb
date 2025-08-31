class Layout::CardListSearchAndFilters < ApplicationComponent

  def initialize(
    search_object:,
    url:,
    title: "Search & Filters",
    fields: [],
    **system_arguments
  )
    @search_object = search_object
    @url = url
    @title = title
    @fields = fields
    super(**system_arguments)
  end

  private

  attr_reader :search_object, :url, :title, :fields

  def container_classes
    "mt-5"
  end

  def title_classes
    "f4 text-semibold mb-3"
  end

  def box_classes
    "Box"
  end

  def box_body_classes
    "Box-body"
  end

  def form_classes
    "d-flex flex-items-center gap-3"
  end

  def field_container_classes
    "flex-1"
  end

  def label_classes
    "form-label sr-only"
  end

  def input_classes
    "form-control"
  end

  def search_button_classes
    "btn btn-primary"
  end

  def clear_button_classes
    "btn"
  end

  def render?
    fields.any?
  end

  def has_search_params?
    search_object&.conditions&.any? { |condition| condition.values.any?(&:present?) }
  end
end
