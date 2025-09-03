class Models::Documents::DocumentFormComponent < ApplicationComponent
  def initialize(document:, submit_text: "Save Document", cancel_url: nil, **system_arguments)
    @document = document
    @submit_text = submit_text
    @cancel_url = cancel_url || models_documents_path
    @system_arguments = system_arguments
  end

  private

  attr_reader :document, :submit_text, :cancel_url, :system_arguments

  def form_url
    document.persisted? ? models_document_path(document) : models_documents_path
  end

  def form_method
    document.persisted? ? :patch : :post
  end

  def status_options
    return [] unless defined?(Status)
    options_from_collection_for_select(Status.all, :id, :name, document.status_id)
  end

  def scenario_options
    return [] unless defined?(Scenario)
    options_from_collection_for_select(Scenario.all, :id, :name, document.scenario_id)
  end

  def folder_options
    return [] unless defined?(Folder)
    # Only show folders the user can access
    folders = current_user.admin? ? Folder.all : Folder.joins(team: :team_memberships).where(team_memberships: { user: current_user })
    options_from_collection_for_select(folders, :id, :name, document.folder_id)
  end

  def current_user
    # This should be available from the component context
    @current_user ||= helpers.current_user if helpers.respond_to?(:current_user)
  end
end
