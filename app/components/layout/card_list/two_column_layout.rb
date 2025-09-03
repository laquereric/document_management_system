class Layout::CardList::TwoColumnLayout < ApplicationComponent
  def initialize(
    gap: "24px",
    left_column_class: "flex-1 mb-4 mb-lg-0",
    right_column_class: "flex-1",
    **system_arguments
  )
    @gap = gap
    @left_column_class = left_column_class
    @right_column_class = right_column_class
    super(**system_arguments)
  end

  private

  attr_reader :gap, :left_column_class, :right_column_class

  def container_classes
    "d-lg-flex"
  end

  def container_styles
    "gap: #{gap};"
  end
end
