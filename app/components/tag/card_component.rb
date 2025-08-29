class Tag::CardComponent < ApplicationComponent
  def initialize(tag:, show_actions: true, admin_context: false, **system_arguments)
    @tag = tag
    @show_actions = show_actions
    @admin_context = admin_context
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :tag, :show_actions, :admin_context, :system_arguments

  def card_classes
    "Box mb-4 mb-lg-0 #{system_arguments[:class]}".strip
  end

  def formatted_date
    tag.created_at&.strftime("%b %d, %Y") || "Unknown date"
  end

  def tag_color_style
    return "" unless tag.color.present?
    "background-color: #{tag.color}; color: #{contrast_color};"
  end

  def contrast_color
    return "#000" unless tag.color.present?
    # Simple contrast calculation - if color is dark, use white text
    hex = tag.color.gsub('#', '')
    rgb = hex.scan(/../).map { |color| color.to_i(16) }
    brightness = (rgb[0] * 299 + rgb[1] * 587 + rgb[2] * 114) / 1000
    brightness > 128 ? "#000" : "#fff"
  end

  def usage_count
    tag.respond_to?(:usage_count) ? tag.usage_count : tag.documents.count
  end

  def base_path_prefix
    admin_context ? "admin_" : ""
  end

  def tag_path_helper
    admin_context ? admin_tag_path(tag) : tag_path(tag)
  end

  def edit_tag_path_helper
    admin_context ? edit_admin_tag_path(tag) : edit_tag_path(tag)
  end

  def delete_tag_path_helper
    admin_context ? admin_tag_path(tag) : tag_path(tag)
  end
end
