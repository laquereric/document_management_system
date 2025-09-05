class Local::Beta::BorderBox::Row < ApplicationComponent
  def initialize(**system_arguments)
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :system_arguments

  def row_classes
    "Box-row #{system_arguments[:class]}"
  end
end
