class Ui::EmptyStateComponent < ApplicationComponent
  def initialize(
    title:,
    description:,
    icon: "inbox",
    action: nil,
    action_text: nil,
    action_url: nil,
    **system_arguments
  )
    @title = title
    @description = description
    @icon = icon
    @action = action
    @action_text = action_text
    @action_url = action_url
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :description, :icon, :action, :action_text, :action_url, :system_arguments

  def container_classes
    "text-center py-5 #{system_arguments[:class]}"
  end

  def has_action?
    (action_text.present? && action_url.present?) || action.present?
  end

  def action_text_value
    if action.is_a?(Hash)
      action[:text]
    else
      action_text
    end
  end

  def action_url_value
    if action.is_a?(Hash)
      action[:url]
    else
      action_url
    end
  end

  def action_classes
    if action.is_a?(Hash) && action[:class].present?
      "btn #{action[:class]}"
    else
      "btn btn-primary"
    end
  end

  # Context methods for the template
  def template_context
    {
      container_classes: container_classes,
      has_action?: has_action?,
      action_text_value: action_text_value,
      action_url_value: action_url_value,
      action_classes: action_classes,
      title: title,
      description: description,
      icon: icon,
      action: action,
      action_text: action_text,
      action_url: action_url,
      link_to: method(:link_to)
    }
  end
end
