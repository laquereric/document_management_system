class User::Dashboard::StatsCardComponent < ApplicationComponent
  COLOR_OPTIONS = %i[default accent success attention severe danger].freeze

  def initialize(title:, value:, icon:, color: :default, **system_arguments)
    @title = title
    @value = value
    @icon = icon
    @color = fetch_or_fallback(COLOR_OPTIONS, color, :default)
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :value, :icon, :color, :system_arguments

  def card_classes
    "Box border #{border_color_class} #{system_arguments[:class]}"
  end

  def value_color_class
    case color
    when :accent
      "color-fg-accent"
    when :success
      "color-fg-success"
    when :attention
      "color-fg-attention"
    when :severe
      "color-fg-severe"
    when :danger
      "color-fg-danger"
    else
      "color-fg-default"
    end
  end

  def icon_color_class
    case color
    when :accent
      "color-fg-accent"
    when :success
      "color-fg-success"
    when :attention
      "color-fg-attention"
    when :severe
      "color-fg-severe"
    when :danger
      "color-fg-danger"
    else
      "color-fg-muted"
    end
  end

  def border_color_class
    case color
    when :accent
      "border-accent-emphasis"
    when :success
      "border-success-emphasis"
    when :attention
      "border-attention-emphasis"
    when :severe
      "border-severe-emphasis"
    when :danger
      "border-danger-emphasis"
    else
      "border-default"
    end
  end

  def render_icon_svg(icon)
    case icon
    when 'file-text'
      '<path d="M2 1.75C2 .784 2.784 0 3.75 0h6.586c.464 0 .909.184 1.237.513l2.914 2.914c.329.328.513.773.513 1.237v9.586A1.75 1.75 0 0 1 13.25 16h-9.5A1.75 1.75 0 0 1 2 14.25Zm1.75-.25a.25.25 0 0 0-.25.25v12.5c0 .138.112.25.25.25h9.5a.25.25 0 0 0 .25-.25V6H9.75A1.75 1.75 0 0 1 8 4.25V1.5Zm6.75.062V4.25c0 .138.112.25.25.25h2.688l-.011-.013-2.914-2.914-.013-.011Z"></path>'.html_safe
    when 'people'
      '<path d="M2 5.5a3.5 3.5 0 1 1 5.898 2.549 5.508 5.508 0 0 1 3.034 4.084.75.75 0 1 1-1.482.235 4.001 4.001 0 0 0-7.9 0 .75.75 0 0 1-1.482-.236A5.507 5.507 0 0 1 3.102 8.05 3.493 3.493 0 0 1 2 5.5ZM11 4a3.001 3.001 0 0 1 2.22 5.018 5.01 5.01 0 0 1 2.56 3.012.749.749 0 0 1-.885.954.752.752 0 0 1-.665-.57 3.51 3.51 0 0 0-2.522-2.372.75.75 0 0 1-.574-.73v-.352a.75.75 0 0 1 .416-.672A1.5 1.5 0 0 0 11 4Zm-5.5 1.5a2 2 0 1 0 0 4 2 2 0 0 0 0-4ZM9.5 6a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Z"></path>'.html_safe
    when 'person-badge'
      '<path d="M10.561 8.073a6.005 6.005 0 0 1 3.432 5.142.75.75 0 1 1-1.498.07 4.5 4.5 0 0 0-8.99 0 .75.75 0 0 1-1.498-.07 6.004 6.004 0 0 1 3.431-5.142 3.999 3.999 0 1 1 5.123 0ZM10.5 5a2.5 2.5 0 1 0-5 0 2.5 2.5 0 0 0 5 0Z"></path>'.html_safe
    when 'clock'
      '<path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0ZM1.5 8a6.5 6.5 0 1 0 13 0 6.5 6.5 0 0 0-13 0Zm7-3.25v2.992l2.028.812a.75.75 0 0 1-.557 1.392l-2.5-1A.751.751 0 0 1 7 8.25v-3.5a.75.75 0 0 1 1.5 0Z"></path>'.html_safe
    else
      '<path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"></path>'.html_safe
    end
  end

  # Context methods for the template
  def template_context
    {
      card_classes: card_classes,
      value_color_class: value_color_class,
      icon_color_class: icon_color_class,
      title: title,
      value: value,
      icon: icon,
      render_icon_svg: method(:render_icon_svg)
    }
  end
end
