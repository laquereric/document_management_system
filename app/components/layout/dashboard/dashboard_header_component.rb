class Layout::Dashboard::DashboardHeaderComponent < ApplicationComponent
  def initialize(title:, description:, **system_arguments)
    @title = title
    @description = description
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :description, :system_arguments

  def header_classes
    "mb-4 #{system_arguments[:class]}"
  end

  def template_context
    {
      title: title,
      description: description,
      header_classes: header_classes
    }
  end
end
