# Document form component for creating and editing documents

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
      statuses: statuses,
      scenarios: scenarios,
      folders: folders,
      form_url: form_url,
      form_method: form_method,
      submit_text: submit_text,
      cancel_url: cancel_url,
      document: document,
      document_path: method(:document_path),
      documents_path: documents_path,
      Status: defined?(Status) ? Status : nil,
      Scenario: defined?(Scenario) ? Scenario : nil,
      Folder: defined?(Folder) ? Folder : nil
    }
  end
end
