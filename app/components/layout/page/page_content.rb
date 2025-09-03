class Layout::Page::PageContent < ApplicationComponent

  def initialize(
    padding: :default,
    **system_arguments
  )
    @padding = padding
    super(**system_arguments)
  end

  private

  attr_reader :padding

  def container_classes
    base_classes = "container-lg px-3"
    
    case padding
    when :none
      base_classes
    when :small
      "#{base_classes} py-2"
    when :default
      "#{base_classes} py-4"
    when :large
      "#{base_classes} py-6"
    else
      base_classes
    end
  end

  def render?
    content.present?
  end
end
