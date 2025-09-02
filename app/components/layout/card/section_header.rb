class Layout::SectionHeader < ApplicationComponent
  def initialize(
    title:,
    count: nil,
    controls: nil,
    **system_arguments
  )
    @title = title
    @count = count
    @controls = controls
    super(**system_arguments)
  end

  private

  attr_reader :title, :count, :controls

  def has_count?
    count.present?
  end

  def has_controls?
    controls.present?
  end
end
