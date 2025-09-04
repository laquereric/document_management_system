class Primer::FlashComponent < ApplicationComponent
  include Primer::ViewComponents::Concerns::TestSelectorArgument

  SCHEME_MAPPINGS = {
    success: {
      icon: :check_circle_fill,
      classes: "flash-success"
    },
    warning: {
      icon: :alert_fill,
      classes: "flash-warn"
    },
    danger: {
      icon: :stop_fill,
      classes: "flash-error"
    },
    default: {
      icon: :info,
      classes: "flash"
    }
  }.freeze

  def initialize(
    scheme: :default,
    full: false,
    spacious: false,
    dismissible: false,
    icon: nil,
    **system_arguments
  )
    @scheme = fetch_or_fallback(SCHEME_MAPPINGS.keys, scheme, :default)
    @full = full
    @spacious = spacious
    @dismissible = dismissible
    @icon = icon || SCHEME_MAPPINGS[@scheme][:icon]
    @system_arguments = deny_tag_argument(**system_arguments)
    @system_arguments[:tag] = :div
    @system_arguments[:classes] = class_names(
      "flash",
      SCHEME_MAPPINGS[@scheme][:classes],
      "flash-full": @full,
      "py-4": @spacious,
      system_arguments[:classes]
    )
  end

  private

  attr_reader :scheme, :full, :spacious, :dismissible, :icon

  def render_icon?
    @icon.present?
  end

  def dismissible?
    @dismissible
  end
end
