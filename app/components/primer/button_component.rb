class Primer::ButtonComponent < ApplicationComponent
  include Primer::ViewComponents::Concerns::TestSelectorArgument

  SCHEME_MAPPINGS = {
    default: "",
    primary: "btn-primary",
    danger: "btn-danger",
    outline: "btn-outline",
    invisible: "btn-invisible"
  }.freeze

  SIZE_MAPPINGS = {
    small: "btn-sm",
    medium: "",
    large: "btn-large"
  }.freeze

  def initialize(
    scheme: :default,
    size: :medium,
    block: false,
    icon: nil,
    icon_position: :leading,
    disabled: false,
    loading: false,
    href: nil,
    **system_arguments
  )
    @scheme = fetch_or_fallback(SCHEME_MAPPINGS.keys, scheme, :default)
    @size = fetch_or_fallback(SIZE_MAPPINGS.keys, size, :medium)
    @block = block
    @icon = icon
    @icon_position = icon_position
    @disabled = disabled
    @loading = loading
    @href = href
    @system_arguments = deny_tag_argument(**system_arguments)
    @system_arguments[:tag] = @href ? :a : :button
    @system_arguments[:href] = @href if @href
    @system_arguments[:disabled] = @disabled if @disabled && !@href
    @system_arguments[:type] ||= "button" unless @href
    @system_arguments[:classes] = class_names(
      "btn",
      SCHEME_MAPPINGS[@scheme],
      SIZE_MAPPINGS[@size],
      "btn-block": @block,
      "disabled": @disabled && @href,
      system_arguments[:classes]
    )
  end

  private

  attr_reader :scheme, :size, :block, :icon, :icon_position, :disabled, :loading, :href

  def render_content
    if loading
      render_loading_content
    elsif icon
      render_icon_content
    else
      content
    end
  end

  def render_loading_content
    safe_join([
      render_loading_spinner,
      content_tag(:span, content, class: "ml-2")
    ].compact)
  end

  def render_loading_spinner
    content_tag(
      :span,
      "",
      class: "AnimatedEllipsis",
      "aria-label": "Loading"
    )
  end

  def render_icon_content
    if icon_position == :trailing
      safe_join([
        content_tag(:span, content),
        render_icon
      ].compact)
    else
      safe_join([
        render_icon,
        content_tag(:span, content)
      ].compact)
    end
  end

  def render_icon
    render(Primer::Beta::Octicon.new(
      icon: icon,
      size: icon_size,
      mr: icon_position == :leading ? 2 : 0,
      ml: icon_position == :trailing ? 2 : 0
    ))
  end

  def icon_size
    case size
    when :small
      :small
    when :large
      :medium
    else
      :small
    end
  end
end
