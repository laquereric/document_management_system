class Local::TextInputComponent < ApplicationComponent
  def initialize(
    name:,
    value: nil,
    placeholder: nil,
    size: :medium,
    disabled: false,
    required: false,
    type: :text,
    **system_arguments
  )
    @name = name
    @value = value
    @placeholder = placeholder
    @size = size
    @disabled = disabled
    @required = required
    @type = type
    @system_arguments = deny_tag_argument(**system_arguments)
    @system_arguments[:tag] = :input
    @system_arguments[:type] = @type
    @system_arguments[:name] = @name
    @system_arguments[:value] = @value
    @system_arguments[:placeholder] = @placeholder
    @system_arguments[:disabled] = @disabled if @disabled
    @system_arguments[:required] = @required if @required
    @system_arguments[:classes] = class_names(
      "FormControl-input",
      size_classes,
      system_arguments[:classes]
    )
  end

  private

  attr_reader :name, :value, :placeholder, :size, :disabled, :required, :type

  def size_classes
    case size
    when :small
      "FormControl-small"
    when :large
      "FormControl-large"
    else
      ""
    end
  end
end
