class Forms::DocumentFormComponent < ApplicationComponent
  def initialize(document:, folder: nil, **system_arguments)
    @document = document
    @folder = folder || document.folder
    @statuses = Status.all
    @scenario_types = ScenarioType.all
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :document, :folder, :statuses, :scenario_types, :system_arguments

  def form_classes
    "needs-validation #{system_arguments[:class]}"
  end

  def submit_text
    document.new_record? ? "Create Document" : "Update Document"
  end

  def form_url
    document.new_record? ? folder_documents_path(folder) : document_path(document)
  end

  def form_method
    document.new_record? ? :post : :patch
  end
end
