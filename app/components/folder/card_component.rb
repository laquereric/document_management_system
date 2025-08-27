class Folder::CardComponent < ApplicationComponent
  def initialize(folder:, show_actions: true, **system_arguments)
    @folder = folder
    @show_actions = show_actions
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :folder, :show_actions, :system_arguments

  def card_classes
    "Box Box--condensed #{system_arguments[:class]}"
  end

  def title_classes
    "Box-title"
  end

  def content_classes
    "Box-body"
  end

  def footer_classes
    "Box-footer"
  end

  def truncated_description
    description = folder.description || ""
    description.length > 150 ? "#{description[0..150]}..." : description
  end

  def formatted_date
    folder.created_at&.strftime("%b %d, %Y") || "Unknown date"
  end

  def team_name
    folder.team&.name || "Unknown team"
  end

  def organization_name
    folder.team&.organization&.name || "Unknown organization"
  end

  def parent_folder_name
    folder.parent_folder&.name || "Root"
  end

  def document_count
    folder.documents.count
  end

  def subfolder_count
    folder.subfolders.count
  end
end
