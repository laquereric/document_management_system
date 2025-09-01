# Document actions menu component

class User::Document::ActionsMenuComponent < ApplicationComponent
  def initialize(document:, **system_arguments)
    @document = document
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :document, :system_arguments

  def can_edit?
    # This would integrate with CanCanCan
    true # Placeholder
  end

  def can_delete?
    # This would integrate with CanCanCan
    true # Placeholder
  end

  def menu_items
    items = [
      {
        label: "View",
        icon: :eye,
        href: document_path(document)
      }
    ]

    if can_edit?
      items += [
        {
          label: "Edit",
          icon: :pencil,
          href: edit_document_path(document)
        },
        {
          label: "Move",
          icon: :arrow_right,
          href: "#",
          data: { action: "document:move" }
        }
      ]
    end

    if document.file.attached?
      items << {
        label: "Download",
        icon: :download,
        href: "#", # Would link to file download
        target: "_blank"
      }
    end

    if can_delete?
      items << {
        label: "Delete",
        icon: :trash,
        href: "#",
        data: { 
          action: "document:delete",
          confirm: "Are you sure you want to delete this document?"
        },
        classes: "color-fg-danger"
      }
    end

    items
  end
end
