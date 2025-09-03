class Layout::Dashboard::StatisticsGridComponent < ApplicationComponent
  def initialize(statistics:, **system_arguments)
    @statistics = statistics
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :statistics, :system_arguments

  def grid_classes
    "d-flex flex-wrap gap-3 mb-5 #{system_arguments[:class]}"
  end

  def has_statistics?
    statistics.any?
  end

  def template_context
    {
      statistics: statistics,
      grid_classes: grid_classes,
      has_statistics?: has_statistics?
    }
  end
end
