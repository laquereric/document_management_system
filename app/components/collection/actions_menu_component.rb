# Generic actions menu component for various resources

class Collection::ActionsMenuComponent < ApplicationComponent
  def initialize(resource:, resource_type: nil, **system_arguments)
    @resource = resource
    @resource_type = resource_type || resource.class.name.downcase
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :resource, :resource_type, :system_arguments

  def can_edit?
    # This would integrate with CanCanCan
    true # Placeholder
  end

  def can_delete?
    # This would integrate with CanCanCan
    true # Placeholder
  end

  def menu_items
    case resource_type
    when 'document'
      document_menu_items
    when 'user'
      user_menu_items
    when 'organization'
      organization_menu_items
    when 'folder'
      folder_menu_items
    when 'team'
      team_menu_items
    when 'scenario'
      scenario_menu_items
    else
      default_menu_items
    end
  end

  def document_menu_items
    items = [
      {
        label: "View",
        icon: :eye,
        href: document_path(resource)
      }
    ]

    if can_edit?
      items += [
        {
          label: "Edit",
          icon: :pencil,
          href: edit_document_path(resource)
        },
        {
          label: "Move",
          icon: :arrow_right,
          href: "#",
          data: { action: "document:move" }
        }
      ]
    end

    if resource.file.attached?
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

  def user_menu_items
    items = [
      {
        label: "View",
        icon: :eye,
        href: user_path(resource)
      }
    ]

    if can_edit?
      items << {
        label: "Edit",
        icon: :pencil,
        href: edit_user_path(resource)
      }
    end

    if can_delete?
      items << {
        label: "Delete",
        icon: :trash,
        href: "#",
        data: { 
          action: "user:delete",
          confirm: "Are you sure you want to delete this user?"
        },
        classes: "color-fg-danger"
      }
    end

    items
  end

  def organization_menu_items
    items = [
      {
        label: "View",
        icon: :eye,
        href: organization_path(resource)
      }
    ]

    if can_edit?
      items << {
        label: "Edit",
        icon: :pencil,
        href: edit_organization_path(resource)
      }
    end

    if can_delete?
      items << {
        label: "Delete",
        icon: :trash,
        href: "#",
        data: { 
          action: "organization:delete",
          confirm: "Are you sure you want to delete this organization?"
        },
        classes: "color-fg-danger"
      }
    end

    items
  end

  def folder_menu_items
    items = [
      {
        label: "View",
        icon: :eye,
        href: folder_path(resource)
      }
    ]

    if can_edit?
      items << {
        label: "Edit",
        icon: :pencil,
        href: edit_folder_path(resource)
      }
    end

    if can_delete?
      items << {
        label: "Delete",
        icon: :trash,
        href: "#",
        data: { 
          action: "folder:delete",
          confirm: "Are you sure you want to delete this folder?"
        },
        classes: "color-fg-danger"
      }
    end

    items
  end

  def team_menu_items
    items = [
      {
        label: "View",
        icon: :eye,
        href: team_path(resource)
      }
    ]

    if can_edit?
      items << {
        label: "Edit",
        icon: :pencil,
        href: edit_team_path(resource)
      }
    end

    if can_delete?
      items << {
        label: "Delete",
        icon: :trash,
        href: "#",
        data: { 
          action: "team:delete",
          confirm: "Are you sure you want to delete this team?"
        },
        classes: "color-fg-danger"
      }
    end

    items
  end

  def scenario_menu_items
    items = [
      {
        label: "View",
        icon: :eye,
        href: scenario_path(resource)
      }
    ]

    if can_edit?
      items << {
        label: "Edit",
        icon: :pencil,
        href: edit_scenario_path(resource)
      }
    end

    if can_delete?
      items << {
        label: "Delete",
        icon: :trash,
        href: "#",
        data: { 
          action: "scenario:delete",
          confirm: "Are you sure you want to delete this scenario?"
        },
        classes: "color-fg-danger"
      }
    end

    items
  end

  def default_menu_items
    [
      {
        label: "View",
        icon: :eye,
        href: "#"
      }
    ]
  end

  # Context methods for the template
  def template_context
    {
      menu_items: menu_items,
      resource: resource,
      resource_type: resource_type
    }
  end
end
