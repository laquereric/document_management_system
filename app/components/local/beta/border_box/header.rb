class Local::Beta::BorderBox::Header < ApplicationComponent
  def initialize(**system_arguments)
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :system_arguments

  def header_classes
    "Box-header #{system_arguments[:class]}"
  end
end
