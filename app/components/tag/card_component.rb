class Tag::CardComponent < ApplicationComponent
  def initialize(tag:, show_actions: true, **system_arguments)
    @tag = tag
    @show_actions = show_actions
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :tag, :show_actions, :system_arguments

  def card_classes
    "Box Box--condensed #{system_arguments[:class]}"
  end

  def title_classes
    "Box-title"
  end

  def content_classes
    "Box-body"
  end

  def footer_classes
    "Box-footer"
  end

  def formatted_date
    tag.created_at&.strftime("%b %d, %Y") || "Unknown date"
  end

  def color_style
    "background-color: #{tag.color};"
  end
end
