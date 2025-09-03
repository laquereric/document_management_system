class Primer::FormFieldComponent < ApplicationComponent
  def initialize(
    label:,
    required: false,
    caption: nil,
    validation_message: nil,
    **system_arguments
  )
    @label = label
    @required = required
    @caption = caption
    @validation_message = validation_message
    @system_arguments = deny_tag_argument(**system_arguments)
    @system_arguments[:tag] = :div
    @system_arguments[:classes] = class_names(
      "FormControl",
      "mb-3",
      "FormControl--error": has_validation_message?,
      system_arguments[:classes]
    )
  end

  private

  attr_reader :label, :required, :caption, :validation_message

  def render_label
    render(Primer::BaseComponent.new(
      tag: :label,
      classes: "FormControl-label"
    )) do
      safe_join([
        content_tag(:span, label),
        render_required_indicator
      ].compact)
    end
  end

  def render_required_indicator
    return unless required

    content_tag(:span, "*", class: "color-fg-danger ml-1")
  end

  def render_input_wrapper
    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "FormControl-input-wrap"
    )) do
      content
    end
  end

  def render_caption
    return unless caption.present?

    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "FormControl-caption"
    )) do
      caption
    end
  end

  def render_validation_message
    return unless has_validation_message?

    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "FormControl-inlineValidation"
    )) do
      safe_join([
        render(Primer::Beta::Octicon.new(
          icon: :alert_fill,
          size: :small,
          mr: 1
        )),
        content_tag(:span, validation_message)
      ])
    end
  end

  def has_validation_message?
    validation_message.present?
  end
end
