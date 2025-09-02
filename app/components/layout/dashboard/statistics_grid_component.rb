class Layout::Dashboard::StatisticsGridComponent < ApplicationComponent
  def initialize(title:, statistics:, **system_arguments)
    @title = title
    @statistics = statistics
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :statistics, :system_arguments

  def title_classes
    "f4 text-semibold mb-3"
  end

  def grid_classes
    "d-flex flex-wrap #{system_arguments[:class]}"
  end

  def card_container_classes
    "flex-1"
  end

  def card_styles
    "min-width: 240px;"
  end

  # Context methods for the template
  def template_context
    {
      title_classes: title_classes,
      grid_classes: grid_classes,
      card_container_classes: card_container_classes,
      card_styles: card_styles,
      title: title,
      statistics: statistics
    }
  end
end
