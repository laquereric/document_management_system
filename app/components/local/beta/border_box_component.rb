class Local::Beta::BorderBox < ApplicationComponent
  def initialize(padding: :normal, **system_arguments)
    @padding = padding
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :padding, :system_arguments

  def box_classes
    base_classes = "Box"
    padding_classes = padding_classes_for(padding)
    "#{base_classes} #{padding_classes}"
  end

  def padding_classes_for(padding)
    case padding
    when :condensed
      "p-3"
    when :spacious
      "p-4"
    else
      "p-3"
    end
  end

  def template_context
    {
      box_classes: box_classes,
      padding: padding
    }
  end
end
