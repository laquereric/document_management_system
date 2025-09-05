class Local::DashboardStatsCardComponent < ApplicationComponent
  def initialize(
    title:,
    value:,
    subtitle: nil,
    icon: :number,
    color: :primary,
    trend: nil,
    trend_direction: nil,
    **system_arguments
  )
    @title = title
    @value = value
    @subtitle = subtitle
    @icon = icon
    @color = color
    @trend = trend
    @trend_direction = trend_direction
    @system_arguments = system_arguments
  end

  private

  attr_reader :title, :value, :subtitle, :icon, :color, :trend, :trend_direction

  def render_content
    render(Primer::CardComponent.new(padding: :normal)) do
      content_tag(:div, class: "d-flex flex-items-center") do
        safe_join([
          render_icon_section,
          render_stats_section
        ])
      end
    end
  end

  def render_icon_section
    content_tag(:div, class: "mr-3") do
      render(Primer::Beta::CircleBadge.new(
        variant: circle_badge_variant,
        size: :large
      )) do
        render(Primer::Beta::Octicon.new(
          icon: icon,
          size: :medium
        ))
      end
    end
  end

  def render_stats_section
    content_tag(:div, class: "flex-1") do
      safe_join([
        render_value,
        render_title,
        render_subtitle,
        render_trend_section
      ].compact)
    end
  end

  def render_value
    content_tag(:div, value, class: "f3 text-semibold mb-1")
  end

  def render_title
    content_tag(:div, title, class: "f5 color-fg-muted mb-1")
  end

  def render_subtitle
    return unless has_subtitle?

    content_tag(:div, subtitle, class: "f6 color-fg-muted")
  end

  def render_trend_section
    return unless has_trend?

    content_tag(:div, class: "d-flex flex-items-center gap-1 mt-2") do
      safe_join([
        render_trend_icon,
        render_trend_text
      ])
    end
  end

  def render_trend_icon
    render(Primer::Beta::Octicon.new(
      icon: trend_icon,
      color: trend_color,
      size: :small
    ))
  end

  def render_trend_text
    content_tag(:span, trend, class: "f6 color-fg-#{trend_color}")
  end

  # Helper methods
  def has_subtitle?
    subtitle.present?
  end

  def has_trend?
    trend.present? && trend_direction.present?
  end

  def circle_badge_variant
    case color.to_sym
    when :success
      :success
    when :danger
      :danger
    when :warning
      :warning
    else
      :primary
    end
  end

  def trend_icon
    case trend_direction.to_sym
    when :up
      :arrow_up
    when :down
      :arrow_down
    else
      :dash
    end
  end

  def trend_color
    case trend_direction.to_sym
    when :up
      :success
    when :down
      :danger
    else
      :muted
    end
  end
end
