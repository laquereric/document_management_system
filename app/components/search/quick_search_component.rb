# Quick search component for the header

class Search::QuickSearchComponent < ApplicationComponent
  def initialize(
    placeholder: "Search...",
    value: nil,
    size: :medium,
    **system_arguments
  )
    @placeholder = placeholder
    @value = value
    @size = size
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :placeholder, :value, :size, :system_arguments

  def search_form_classes
    "d-flex flex-items-center"
  end

  def input_size_class
    case size
    when :small then "input-sm"
    when :large then "input-lg"
    else ""
    end
  end
end
