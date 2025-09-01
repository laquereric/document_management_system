class Forms::DocumentFormComponent < ApplicationComponent
  def initialize(document:, submit_text: "Save Document", cancel_url: nil, **system_arguments)
    @document = document
    @submit_text = submit_text
    @cancel_url = cancel_url
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :document, :submit_text, :cancel_url, :system_arguments

  def form_classes
    "#{system_arguments[:class]}"
  end

  def title_field_classes
    "FormControl-input FormControl-large"
  end

  def content_field_classes
    "FormControl-textarea"
  end

  def url_field_classes
    "FormControl-input"
  end

  def select_classes
    "FormControl-select"
  end

  def file_field_classes
    "FormControl-input"
  end

  def submit_button_classes
    "btn btn-primary"
  end

  def cancel_button_classes
    "btn"
  end

  def statuses
    defined?(Status) ? Status.all : []
  end

  def scenarios
    defined?(Scenario) ? Scenario.all : []
  end

  def folders
    defined?(Folder) ? Folder.all : []
  end

  def form_url
    if document.persisted?
      document_path(document)
    else
      documents_path
    end
  end

  def form_method
    document.persisted? ? :patch : :post
  end

  # Context methods for the template
  def template_context
    {
      form_classes: form_classes,
      title_field_classes: title_field_classes,
      content_field_classes: content_field_classes,
      url_field_classes: url_field_classes,
      select_classes: select_classes,
      file_field_classes: file_field_classes,
      submit_button_classes: submit_button_classes,
      cancel_button_classes: cancel_button_classes,
      statuses: statuses,
      scenarios: scenarios,
      folders: folders,
      form_url: form_url,
      form_method: form_method,
      submit_text: submit_text,
      cancel_url: cancel_url
    }
  end
end
