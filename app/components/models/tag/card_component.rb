class Models::Tag::CardComponent < Layout::Card::CardComponent

  def initialize(tag:, show_actions: true, admin_context: false, **system_arguments)
    @tag = tag
    @admin_context = admin_context
    initialize_card_base(show_actions: show_actions, **system_arguments)
  end

  private

  attr_reader :tag, :admin_context

  def card_classes
    "#{base_card_classes} mb-4 mb-lg-0 #{system_arguments[:class]}".strip
  end

  def formatted_date
    super(tag.created_at)
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
    tag.respond_to?(:usage_count) ? tag.usage_count : safe_count(tag.documents)
  end

  def base_path_prefix
    admin_context ? "admin_" : ""
  end

  def show_path
    admin_context ? models_tag_path(tag) : tag_path(tag)
  end

  def edit_path
    admin_context ? models_edit_tag_path(tag) : edit_tag_path(tag)
  end

  def delete_path
    admin_context ? models_tag_path(tag) : tag_path(tag)
  end
end
