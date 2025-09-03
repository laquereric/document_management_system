class Primer::CardComponent < ApplicationComponent
  include Primer::ViewComponents::Concerns::TestSelectorArgument

  def initialize(
    padding: :normal,
    condensed: false,
    spacious: false,
    **system_arguments
  )
    @padding = padding
    @condensed = condensed
    @spacious = spacious
    @system_arguments = deny_tag_argument(**system_arguments)
    @system_arguments[:tag] = :div
    @system_arguments[:classes] = class_names(
      "Box",
      "Box--condensed": @condensed,
      "Box--spacious": @spacious,
      system_arguments[:classes]
    )
  end

  private

  attr_reader :padding, :condensed, :spacious
end
