class TagLabelComponent < ApplicationComponent
  def initialize(tag:, removable: false, document: nil, **system_arguments)
    @tag = tag
    @removable = removable
    @document = document
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :tag, :removable, :document, :system_arguments

  def badge_classes
    "Label Label--secondary mr-1 #{system_arguments[:class]}"
  end

  def remove_button_classes
    "btn-close btn-close-white ml-1"
  end

  def can_remove_tag?
    removable && document.present?
  end

  # Context methods for the template
  def template_context
    {
      badge_classes: badge_classes,
      remove_button_classes: remove_button_classes,
      can_remove_tag?: can_remove_tag?,
      tag: tag,
      removable: removable,
      document: document,
      remove_tag_document_path: method(:remove_tag_document_path),
      button_to: method(:button_to)
    }
  end
end
