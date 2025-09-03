class Layout::Dashboard::DataGridComponent < ApplicationComponent
  def initialize(title:, data:, manage_path:, manage_text:, empty_state:, icon:, **system_arguments)
    @title = title
    @data = data
    @manage_path = manage_path
    @manage_text = manage_text
    @empty_state = empty_state
    @icon = icon
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :data, :manage_path, :manage_text, :empty_state, :icon, :system_arguments

  def has_data?
    data.any?
  end

  def template_context
    {
      title: title,
      data: data,
      manage_path: manage_path,
      manage_text: manage_text,
      empty_state: empty_state,
      icon: icon,
      has_data?: has_data?
    }
  end
end
