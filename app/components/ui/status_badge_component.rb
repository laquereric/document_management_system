class Ui::StatusBadgeComponent < ApplicationComponent
  def initialize(status:, **system_arguments)
    @status = status
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :status, :system_arguments

  def badge_classes
    "Label #{system_arguments[:class]}"
  end

  def badge_style
    "background-color: #{status.color}; color: #{contrast_color(status.color)}"
  end

  def contrast_color(hex_color)
    # Simple contrast calculation - for production, consider using a more sophisticated algorithm
    hex_color = hex_color.gsub('#', '')
    r, g, b = hex_color.scan(/../).map { |c| c.to_i(16) }
    luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
    luminance > 0.5 ? '#000000' : '#ffffff'
  end
end
