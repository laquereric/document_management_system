# Quick search component for the header

class Layout::Navigation::Search::QuickSearchComponent < ApplicationComponent
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

  # Context methods for the template
  def template_context
    {
      search_form_classes: search_form_classes,
      input_size_class: input_size_class,
      placeholder: placeholder,
      value: value,
      size: size,
      form_with: method(:form_with),
      search_index_path: search_index_path,
      link_to: method(:link_to)
    }
  end
end
