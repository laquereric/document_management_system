class Layout::Dashboard::StatisticCardComponent < ApplicationComponent
  def initialize(title:, value:, **system_arguments)
    @title = title
    @value = value
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :value, :system_arguments

  def card_classes
    "Box p-3 #{system_arguments[:class]}"
  end

  def card_styles
    "min-width: 200px;"
  end

  def template_context
    {
      card_classes: card_classes,
      card_styles: card_styles,
      title: title,
      value: value
    }
  end
end
