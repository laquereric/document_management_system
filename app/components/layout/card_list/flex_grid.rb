class Layout::CardList::FlexGrid < ApplicationComponent
  def initialize(
    gap: "16px",
    min_width: "240px",
    max_width: nil,
    wrap: true,
    **system_arguments
  )
    @gap = gap
    @min_width = min_width
    @max_width = max_width
    @wrap = wrap
    super(**system_arguments)
  end

  private

  attr_reader :gap, :min_width, :max_width, :wrap

  def container_classes
    classes = [ "d-flex" ]
    classes << "flex-wrap" if wrap
    classes.join(" ")
  end

  def container_styles
    "gap: #{gap};"
  end

  def item_classes
    "flex-1"
  end

  def item_styles
    styles = [ "min-width: #{min_width};" ]
    styles << "max-width: #{max_width};" if max_width
    styles.join(" ")
  end
end
