class Primer::Beta::CircleBadge < ApplicationComponent
  def initialize(variant: "default", **system_arguments)
    @variant = variant
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :variant, :system_arguments

  def badge_classes
    base_classes = "CircleBadge"
    variant_classes = "CircleBadge--#{variant}"
    "#{base_classes} #{variant_classes}"
  end

  def template_context
    {
      badge_classes: badge_classes,
      variant: variant
    }
  end
end
