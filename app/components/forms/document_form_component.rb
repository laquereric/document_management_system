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

  def scenario_types
    defined?(ScenarioType) ? ScenarioType.all : []
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
end
