class Dashboard::StatsCardComponent < ApplicationComponent
  def initialize(title:, value:, icon:, color: :primary, **system_arguments)
    @title = title
    @value = value
    @icon = icon
    @color = color
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :value, :icon, :color, :system_arguments

  def card_classes
    "Box #{system_arguments[:class]}"
  end
end
