class Layout::CardList::SearchFilterSort::SortDropdownComponent < ApplicationComponent
  def initialize(
    current_sort: nil,
    sort_options: [],
    base_url: nil,
    **system_arguments
  )
    @current_sort = current_sort
    @sort_options = sort_options
    @base_url = base_url
    super(**system_arguments)
  end

  private

  attr_reader :current_sort, :sort_options, :base_url

  def selected_option?(option)
    option[:value] == current_sort
  end

  def option_url(option)
    return base_url unless option[:value]
    "#{base_url}?sort=#{option[:value]}"
  end

  # Context methods for the template
  def template_context
    {
      current_sort: current_sort,
      sort_options: sort_options,
      base_url: base_url,
      selected_option?: method(:selected_option?),
      option_url: method(:option_url)
    }
  end
end
