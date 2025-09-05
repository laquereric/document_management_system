class Local::SelectComponent < ApplicationComponent
  def initialize(
    name:,
    options: [],
    selected: nil,
    placeholder: nil,
    disabled: false,
    required: false,
    multiple: false,
    **system_arguments
  )
    @name = name
    @options = options
    @selected = selected
    @placeholder = placeholder
    @disabled = disabled
    @required = required
    @multiple = multiple
    @system_arguments = deny_tag_argument(**system_arguments)
    @system_arguments[:tag] = :select
    @system_arguments[:name] = @name
    @system_arguments[:disabled] = @disabled if @disabled
    @system_arguments[:required] = @required if @required
    @system_arguments[:multiple] = @multiple if @multiple
    @system_arguments[:classes] = class_names(
      "FormControl-select",
      system_arguments[:classes]
    )
  end

  private

  attr_reader :name, :options, :selected, :placeholder, :disabled, :required, :multiple

  def render_options
    option_elements = []

    if placeholder.present?
      option_elements << content_tag(
        :option,
        placeholder,
        value: "",
        disabled: true,
        selected: selected.blank?
      )
    end

    options.each do |option|
      if option.is_a?(Array)
        option_elements << render_option(option[1], option[0])
      elsif option.is_a?(Hash)
        option_elements << render_option(option[:value], option[:label])
      else
        option_elements << render_option(option, option)
      end
    end

    safe_join(option_elements)
  end

  def render_option(value, label)
    content_tag(
      :option,
      label,
      value: value,
      selected: option_selected?(value)
    )
  end

  def option_selected?(value)
    if multiple
      Array(selected).include?(value)
    else
      selected == value
    end
  end
end
