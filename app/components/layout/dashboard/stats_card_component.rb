class Layout::Dashboard::StatsCardComponent < ApplicationComponent
  def initialize(title:, value:, icon:, color: "accent", subtitle: nil, trend: nil, trend_direction: nil, **system_arguments)
    @title = title
    @value = value
    @icon = icon
    @color = color
    @subtitle = subtitle
    @trend = trend
    @trend_direction = trend_direction
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :value, :icon, :color, :subtitle, :trend, :trend_direction, :system_arguments

  def card_classes
    "Box p-4 #{system_arguments[:class]}"
  end

  def has_subtitle?
    subtitle.present?
  end

  def has_trend?
    trend.present?
  end

  def trend_icon
    case trend_direction
    when 'up'
      'trending-up'
    when 'down'
      'trending-down'
    else
      'dash'
    end
  end

  def trend_color
    case trend_direction
    when 'up'
      'success'
    when 'down'
      'danger'
    else
      'muted'
    end
  end

  # Context methods for the template
  def template_context
    {
      card_classes: card_classes,
      has_subtitle?: has_subtitle?,
      has_trend?: has_trend?,
      title: title,
      value: value,
      icon: icon,
      color: color,
      subtitle: subtitle,
      trend: trend,
      trend_icon: trend_icon,
      trend_color: trend_color
    }
  end
end
