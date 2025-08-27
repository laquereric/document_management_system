class Forms::FolderFormComponent < ApplicationComponent
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

  def name_field_classes
    "form-control input-lg"
  end

  def description_field_classes
    "form-control"
  end

  def select_classes
    "form-select"
  end

  def submit_button_classes
    "btn btn-primary"
  end

  def cancel_button_classes
    "btn"
  end

  def teams
    if current_user.admin?
      Team.all
    else
      current_user.teams
    end
  end

  def parent_folders
    if current_user.admin?
      Folder.all
    else
      team_ids = current_user.teams.pluck(:id)
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
end
