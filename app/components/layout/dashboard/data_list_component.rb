class Layout::Dashboard::DataListComponent < ApplicationComponent
  def initialize(title:, data:, view_all_path: nil, view_all_text: "View All", empty_message: "No data available", **system_arguments)
    @title = title
    @data = data
    @view_all_path = view_all_path
    @view_all_text = view_all_text
    @empty_message = empty_message
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :data, :view_all_path, :view_all_text, :empty_message, :system_arguments

  def has_view_all_link?
    view_all_path.present?
  end

  def has_data?
    data.any?
  end

  def template_context
    {
      title: title,
      data: data,
      view_all_path: view_all_path,
      view_all_text: view_all_text,
      empty_message: empty_message,
      has_view_all_link?: has_view_all_link?,
      has_data?: has_data?
    }
  end
end
