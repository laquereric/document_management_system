class Ui::EmptyStateComponent < ApplicationComponent
  def initialize(title:, description:, icon: "inbox", action_text: nil, action_url: nil, **system_arguments)
    @title = title
    @description = description
    @icon = icon
    @action_text = action_text
    @action_url = action_url
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :description, :icon, :action_text, :action_url, :system_arguments

  def container_classes
    "text-center py-5 #{system_arguments[:class]}"
  end

  def has_action?
    action_text.present? && action_url.present?
  end
end
