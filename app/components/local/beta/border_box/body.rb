class Local::Beta::BorderBox::Body < ApplicationComponent
  def initialize(**system_arguments)
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :system_arguments

  def body_classes
    "Box-body #{system_arguments[:class]}"
  end
end
