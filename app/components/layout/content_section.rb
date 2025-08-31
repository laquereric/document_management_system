class Layout::ContentSection < ApplicationComponent
  def initialize(
    title: nil,
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

  def has_header?
    title.present?
  end
end
