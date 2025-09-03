class Layout::CardList::Statistics::StatisticsGridComponent < ApplicationComponent
  def initialize(
    title: "Overview",
    statistics: [],
    gap: "16px",
    min_width: "240px",
    **system_arguments
  )
    @title = title
    @statistics = statistics
    @gap = gap
    @min_width = min_width
    super(**system_arguments)
  end

  private

  attr_reader :title, :statistics, :gap, :min_width

  def container_classes
    "d-flex flex-wrap"
  end

  def container_styles
    "gap: #{gap};"
  end

  def card_classes
    "flex-1"
  end

  def card_styles
    "min-width: #{min_width};"
  end

  # Context methods for the template
  def template_context
    {
      title: title,
      statistics: statistics,
      gap: gap,
      min_width: min_width,
      container_classes: container_classes,
      container_styles: container_styles,
      card_classes: card_classes,
      card_styles: card_styles
    }
  end
end
