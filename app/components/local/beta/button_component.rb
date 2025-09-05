class Local::Beta::Button < ApplicationComponent
  def initialize(
    scheme: :default,
    size: :medium,
    icon: nil,
    href: nil,
    **system_arguments
  )
    @scheme = scheme
    @size = size
    @icon = icon
    @href = href
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :scheme, :size, :icon, :href, :system_arguments

  def button_classes
    base_classes = ["btn"]
    scheme_classes = scheme_classes_for(scheme)
    size_classes = size_classes_for(size)
    icon_classes = icon_classes_for(icon)
    "#{base_classes.join(' ')} #{scheme_classes} #{size_classes} #{icon_classes}".strip
  end

  def scheme_classes_for(scheme)
    case scheme
    when :primary
      "btn-primary"
    when :secondary
      "btn-secondary"
    when :invisible
      "btn-invisible"
    when :danger
      "btn-danger"
    else
      "btn-default"
    end
  end

  def size_classes_for(size)
    case size
    when :small
      "btn-sm"
    when :large
      "btn-lg"
    else
      ""
    end
  end

  def icon_classes_for(icon)
    return "" unless icon
    "btn-icon"
  end

  def render_icon
    return "" unless icon
    render(Primer::Beta::Octicon.new(icon: icon, size: :small))
  end
end
