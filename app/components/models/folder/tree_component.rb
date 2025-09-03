# Folder tree component for hierarchical navigation

class Models::Folder::TreeComponent < ApplicationComponent
  def initialize(
    folders:,
    current_folder: nil,
    expanded_folders: [],
    show_actions: true,
    **system_arguments
  )
    @folders = folders
    @current_folder = current_folder
    @expanded_folders = expanded_folders
    @show_actions = show_actions
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :folders, :current_folder, :expanded_folders, :show_actions, :system_arguments

  def tree_classes
    "TreeView"
  end

  def root_folders
    folders.select(&:root?)
  end

  def folder_expanded?(folder)
    expanded_folders.include?(folder.id) ||
    (current_folder && current_folder.path.include?(folder.name))
  end

  def folder_selected?(folder)
    current_folder == folder
  end

  def folder_item_classes(folder)
    classes = [ "TreeView-item" ]
    classes << "TreeView-item--expanded" if folder_expanded?(folder)
    classes << "TreeView-item--selected" if folder_selected?(folder)
    classes.join(" ")
  end

  def document_count_text(folder)
    count = folder.total_documents
    return "" if count.zero?
    "(#{count})"
  end

  # Context methods for the template
  def template_context
    {
      tree_classes: tree_classes,
      root_folders: root_folders,
      folder_expanded?: method(:folder_expanded?),
      folder_selected?: method(:folder_selected?),
      folder_item_classes: method(:folder_item_classes),
      document_count_text: method(:document_count_text),
      folders: folders,
      current_folder: current_folder,
      expanded_folders: expanded_folders,
      show_actions: show_actions,
      folder_path: method(:folder_path),
      render: method(:render),
      content_for: method(:content_for),
      Primer: Primer
    }
  end
end
