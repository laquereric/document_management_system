class Local::Beta::BorderBox::Footer < ApplicationComponent
  def initialize(**system_arguments)
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :system_arguments

  def footer_classes
    "Box-footer #{system_arguments[:class]}"
  end
end
