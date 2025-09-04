class Primer::CardComponent < ApplicationComponent


  def initialize(
    padding: :normal,
    condensed: false,
    spacious: false,
    **system_arguments
  )
    @padding = padding
    @condensed = condensed
    @spacious = spacious
    @system_arguments = system_arguments.dup
    @system_arguments[:tag] = :div
    base_classes = ["Box"]
    base_classes << "Box--condensed" if @condensed
    base_classes << "Box--spacious" if @spacious
    base_classes << system_arguments[:classes] if system_arguments[:classes].present?
    
    @system_arguments[:classes] = base_classes.compact.join(" ")
  end

  private

  attr_reader :padding, :condensed, :spacious
end
