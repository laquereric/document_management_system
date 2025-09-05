class Local::DashboardStatsGridComponent < ApplicationComponent
  def initialize(
    statistics: [],
    columns: 4,
    **system_arguments
  )
    @statistics = statistics
    @columns = columns
    @system_arguments = deny_tag_argument(**system_arguments)
    @system_arguments[:tag] = :div
    @system_arguments[:classes] = class_names(
      "d-grid",
      "gap-3",
      "mb-4",
      grid_columns_class,
      system_arguments[:classes]
    )
  end

  private

  attr_reader :statistics, :columns

  def render_statistics
    return render_empty_state unless has_statistics?

    statistics.map do |stat|
      render(Primer::DashboardStatsCardComponent.new(
        title: stat[:title],
        value: stat[:value],
        subtitle: stat[:subtitle],
        icon: stat[:icon] || :number,
        color: stat[:color] || :primary,
        trend: stat[:trend],
        trend_direction: stat[:trend_direction]
      ))
    end
  end

  def render_empty_state
    render(Local::CardComponent.new) do
      content_tag(:div, class: "text-center py-4") do
        safe_join([
          render(Primer::Beta::Octicon.new(
            icon: :graph,
            size: :large,
            color: :fg_muted,
            mb: 2
          )),
          content_tag(:p, "No statistics available", class: "color-fg-muted f5")
        ])
      end
    end
  end

  def has_statistics?
    statistics.present? && statistics.any?
  end

  def grid_columns_class
    case columns
    when 1
      "grid-template-columns-1"
    when 2
      "grid-template-columns-2"
    when 3
      "grid-template-columns-3"
    when 4
      "grid-template-columns-4"
    else
      "grid-template-columns-auto"
    end
  end
end
