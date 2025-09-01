class Forms::TagFormComponent < ApplicationComponent
  def initialize(tag:, submit_text: "Save Tag", cancel_url: nil, **system_arguments)
    @tag = tag
    @submit_text = submit_text
    @cancel_url = cancel_url
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :tag, :submit_text, :cancel_url, :system_arguments

  def form_classes
    "form #{system_arguments[:class]}"
  end

  def name_field_classes
    "form-control input-lg"
  end

  def color_field_classes
    "form-control"
  end

  def submit_button_classes
    "btn btn-primary"
  end

  def cancel_button_classes
    "btn"
  end

  def form_url
    if tag.persisted?
      tag_path(tag)
    else
      tags_path
    end
  end

  def form_method
    tag.persisted? ? :patch : :post
  end

  def color_options
    [
      ['Blue', '#0366d6'],
      ['Green', '#28a745'],
      ['Yellow', '#ffd33d'],
      ['Red', '#d73a49'],
      ['Purple', '#6f42c1'],
      ['Orange', '#f66a0a'],
      ['Pink', '#ea4aaa'],
      ['Gray', '#6a737d']
    ]
  end

  # Context methods for the template
  def template_context
    {
      form_classes: form_classes,
      name_field_classes: name_field_classes,
      color_field_classes: color_field_classes,
      submit_button_classes: submit_button_classes,
      cancel_button_classes: cancel_button_classes,
      form_url: form_url,
      form_method: form_method,
      color_options: color_options,
      submit_text: submit_text,
      cancel_url: cancel_url,
      tag: tag,
      tag_path: method(:tag_path),
      tags_path: tags_path
    }
  end
end
