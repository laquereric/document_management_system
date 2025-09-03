class Models::Folder::FolderFormComponent < ApplicationComponent

  def initialize(folder:, submit_text: "Save Folder", cancel_url: nil, **system_arguments)
    @folder = folder
    @submit_text = submit_text
    @cancel_url = cancel_url
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :folder, :submit_text, :cancel_url, :system_arguments

  def form_classes
    "form #{system_arguments[:class]}"
  end

  def teams
    if helpers.current_user.admin?
      Team.all
    else
      helpers.current_user.teams
    end
  end

  def parent_folders
    if helpers.current_user.admin?
      Folder.all
    else
      team_ids = helpers.current_user.teams.pluck(:id)
      Folder.where(team_id: team_ids)
    end
  end

  def form_url
    if folder.persisted?
      folder_path(folder)
    else
      folders_path
    end
  end

  def form_method
    folder.persisted? ? :patch : :post
  end

  # Context methods for the template
  def template_context
    {
      form_classes: form_classes,
      teams: teams,
      parent_folders: parent_folders,
      form_url: form_url,
      form_method: form_method,
      submit_text: submit_text,
      cancel_url: cancel_url,
      folder: folder,
      current_user: helpers.current_user,
      folder_path: method(:folder_path),
      folders_path: models_folders_path,
      Team: Team,
      Folder: Folder
    }
  end
end
