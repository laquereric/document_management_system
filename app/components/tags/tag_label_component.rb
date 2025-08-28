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
end
