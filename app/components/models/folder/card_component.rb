class Models::Folder::CardComponent < Layout::CardComponent

  def initialize(folder:, show_actions: true, **system_arguments)
    @folder = folder
    initialize_card_base(show_actions: show_actions, **system_arguments)
  end

  private

  attr_reader :folder

  def card_classes
    "#{condensed_card_classes} #{system_arguments[:class]}".strip
  end

  def truncated_description
    super(folder.description)
  end

  def formatted_date
    super(folder.created_at)
  end

  def team_name
    super(folder.team)
  end

  def organization_name
    folder.team&.organization ? safe_name(folder.team.organization, "Unknown organization") : "Unknown organization"
  end

  def parent_folder_name
    safe_name(folder.parent_folder, "Root")
  end

  def document_count
    safe_count(folder.documents)
  end

  def subfolder_count
    safe_count(folder.subfolders)
  end

  # Context methods for the template
  def template_context
    {
      card_classes: card_classes,
      truncated_description: truncated_description,
      formatted_date: formatted_date,
      team_name: team_name,
      organization_name: organization_name,
      parent_folder_name: parent_folder_name,
      document_count: document_count,
      subfolder_count: subfolder_count,
      folder: folder,
      folder_path: method(:folder_path),
      edit_folder_path: method(:edit_folder_path),
      link_to: method(:link_to),
      pluralize: method(:pluralize)
    }
  end
end
