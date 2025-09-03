# Generic actions menu component for various resources

class Layout::Card::ActionsMenuComponent < ApplicationComponent
  def initialize(resource:, resource_type: nil, **system_arguments)
    @resource = resource
    @resource_type = resource_type || resource.class.name.downcase
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :resource, :resource_type, :system_arguments

  def render_icon_path(icon)
    case icon.to_s
    when 'eye'
      '<path d="M8 2c1.981 0 3.671.992 4.933 2.078 1.27 1.091 2.187 2.345 2.637 3.023a1.62 1.62 0 0 1 0 1.798c-.45.678-1.367 1.932-2.637 3.023C11.671 13.008 9.981 14 8 14c-1.981 0-3.671-.992-4.933-2.078C1.797 10.83.88 9.576.43 8.898a1.62 1.62 0 0 1 0-1.798c.45-.678 1.367-1.932 2.637-3.023C4.329 2.992 6.019 2 8 2ZM8 1C3.955 1 1 4.955 1 8s2.955 7 7 7 7-2.955 7-7-2.955-7-7-7Z"></path>'.html_safe
    when 'pencil'
      '<path d="M11.013 1.427a1.75 1.75 0 0 1 2.474 0l1.086 1.086a1.75 1.75 0 0 1 0 2.474l-.897.897a.75.75 0 0 1-.53.22H13.25a.75.75 0 0 1-.75-.75V4.5a.75.75 0 0 1-.75-.75h-1.5a.75.75 0 0 1-.75.75V6.25a.75.75 0 0 1-.75.75H7.5a.75.75 0 0 1-.53-.22l-.897-.897a1.75 1.75 0 0 1 0-2.474l1.086-1.086ZM2.427 9.427a1.75 1.75 0 0 1 0-2.474l.897-.897a.75.75 0 0 1 .53-.22H6.75a.75.75 0 0 1 .75.75v1.5a.75.75 0 0 1-.75.75H4.5a.75.75 0 0 1-.75-.75V9.5a.75.75 0 0 1-.75-.75H3.25a.75.75 0 0 1-.53.22l-.897.897a1.75 1.75 0 0 1 0 2.474l-.897.897a.75.75 0 0 1-.53.22H1.75a.75.75 0 0 1-.75-.75v-1.5a.75.75 0 0 1 .75-.75H3.25a.75.75 0 0 1 .53.22l.897.897Z"></path>'.html_safe
    when 'arrow_right'
      '<path d="M8.22 2.97a.75.75 0 0 1 1.06 0l4.25 4.25a.75.75 0 0 1 0 1.06l-4.25 4.25a.75.75 0 0 1-1.06-1.06l2.97-2.97H3.75a.75.75 0 0 1 0-1.5h7.44L8.22 4.03a.75.75 0 0 1 0-1.06Z"></path>'.html_safe
    when 'download'
      '<path d="M2.75 14A1.75 1.75 0 0 1 1 12.25v-2.5a.75.75 0 0 1 1.5 0v2.5c0 .138.112.25.25.25h10.5a.25.25 0 0 0 .25-.25v-2.5a.75.75 0 0 1 1.5 0v2.5A1.75 1.75 0 0 1 13.25 14H2.75Z"></path><path d="M7 1.75a.75.75 0 0 1 1.5 0v6.376l2.086-2.086a.75.75 0 1 1 1.061 1.06l-3.5 3.5a.75.75 0 0 1-1.06 0l-3.5-3.5a.75.75 0 1 1 1.06-1.06L7 8.126V1.75Z"></path>'.html_safe
    when 'trash'
      '<path d="M10.5 4.5a.75.75 0 0 0-1.5 0v.75h-3v-.75a.75.75 0 0 0-1.5 0v.75H2.5a.75.75 0 0 0 0 1.5h.75v3.75a.75.75 0 0 0 1.5 0v-3.75h.75v3.75a.75.75 0 0 0 1.5 0v-3.75h.75a.75.75 0 0 0 0-1.5h-.75v-.75Z"></path>'.html_safe
    when 'gear'
      '<path d="M8 0a8.2 8.2 0 0 1 .701.031C9.444.095 9.99.645 10.16 1.29l.288 1.107c.018.066.079.158.212.218.906.405 1.678.961 2.26 1.543.134.134.348.134.482 0l.696-.696c.441.441 1.057.441 1.498 0s.441 1.057 0 1.498l-.696.696c-.134.134-.134.348 0 .482.582.582 1.138 1.354 1.543 2.26.06.133.152.194.218.212l1.107.288c.645.17 1.195.716 1.26 1.459C15.969 7.724 16 7.862 16 8s-.031.276-.069.701c-.065.743-.615 1.289-1.26 1.459l-1.107.288c-.066.018-.158.079-.218.212-.405.906-.961 1.678-1.543 2.26-.134.134-.134.348 0 .482l.696.696c.441.441.441 1.057 0 1.498s-1.057.441-1.498 0l-.696-.696c-.134-.134-.348-.134-.482 0-.582.582-1.354 1.138-2.26 1.543-.133.06-.194.152-.212.218l-.288 1.107c-.17.645-.716 1.195-1.459 1.26C8.276 15.969 8.138 16 8 16s-.276-.031-.701-.069c-.743-.065-1.289-.615-1.459-1.26l-.288-1.107c-.018-.066-.079-.158-.212-.218-.906-.405-1.678-.961-2.26-1.543-.134-.134-.348-.134-.482 0l-.696.696c-.441.441-1.057.441-1.498 0s-.441-1.057 0-1.498l.696-.696c.134-.134.134-.348 0-.482-.582-.582-1.138-1.354-1.543-2.26-.06-.133-.152-.194-.218-.212L.569 9.701C-.076 9.531-.626 8.985-.691 8.242 0.031 8.276 0 8.138 0 8s.031-.276.069-.701c.065-.743.615-1.289 1.26-1.459l1.107-.288c.066-.018.158-.079.218-.212.405-.906.961-1.678 1.543-2.26.134-.134.134-.348 0-.482L3.501 2.002c-.441-.441-.441-1.057 0-1.498s1.057-.441 1.498 0l.696.696c.134.134.348.134.482 0 .582-.582 1.354-1.138 2.26-1.543.133-.06.194-.152.212-.218L8.84.569c.17-.645.716-1.195 1.459-1.26C7.724.031 7.862 0 8 0ZM8 1.5a6.5 6.5 0 1 0 0 13 6.5 6.5 0 0 0 0-13Zm0 2a4.5 4.5 0 1 1 0 9 4.5 4.5 0 0 1 0-9Z"></path>'.html_safe
    when 'person'
      '<path d="M10.561 8.073a6.005 6.005 0 0 1 3.432 5.142.75.75 0 1 1-1.498.07 4.5 4.5 0 0 0-8.99 0 .75.75 0 0 1-1.498-.07 6.004 6.004 0 0 1 3.431-5.142 3.999 3.999 0 1 1 5.123 0ZM10.5 5a2.5 2.5 0 1 0-5 0 2.5 2.5 0 0 0 5 0Z"></path>'.html_safe
    when 'organization'
      '<path d="M1.5 14.25c0 .138.112.25.25.25H4v-1.25a.75.75 0 0 1 1.5 0v1.25h2.5v-1.25a.75.75 0 0 1 1.5 0v1.25h2.25a.25.25 0 0 0 .25-.25V1.75a.25.25 0 0 0-.25-.25h-8.5a.25.25 0 0 0-.25.25v12.5ZM1.75 16A1.75 1.75 0 0 1 0 14.25V1.75C0 .784.784 0 1.75 0h8.5C11.216 0 12 .784 12 1.75v12.5c0 .966-.784 1.75-1.75 1.75h-8.5ZM4 1.75A.25.25 0 0 1 4.25 1.5h3.5a.25.25 0 0 1 .25.25v3.5a.25.25 0 0 1-.25.25h-3.5A.25.25 0 0 1 4 5.25v-3.5ZM4.25 1a.75.75 0 0 0-.75.75v3.5c0 .414.336.75.75.75h3.5a.75.75 0 0 0 .75-.75v-3.5a.75.75 0 0 0-.75-.75h-3.5ZM6 10.75A.75.75 0 0 1 6.75 10h3.5a.75.75 0 0 1 0 1.5h-3.5A.75.75 0 0 1 6 10.75ZM6.75 9a.75.75 0 0 0 0 1.5h3.5a.75.75 0 0 0 0-1.5h-3.5ZM6 6.75A.75.75 0 0 1 6.75 6h3.5a.75.75 0 0 1 0 1.5h-3.5A.75.75 0 0 1 6 6.75ZM6.75 5a.75.75 0 0 0 0 1.5h3.5a.75.75 0 0 0 0-1.5h-3.5Z"></path>'.html_safe
    when 'people'
      '<path d="M2 5.5a3.5 3.5 0 1 1 5.898 2.549 5.508 5.508 0 0 1 3.034 4.084.75.75 0 1 1-1.482.235 4.001 4.001 0 0 0-7.9 0 .75.75 0 0 1-1.482-.236A5.507 5.507 0 0 1 3.102 8.05 3.493 3.493 0 0 1 2 5.5ZM11 4a3.001 3.001 0 0 1 2.22 5.018 5.01 5.01 0 0 1 2.56 3.012.749.749 0 0 1-.885.954.752.752 0 0 1-.665-.57 3.51 3.51 0 0 0-2.522-2.372.75.75 0 0 1-.574-.73v-.352a.75.75 0 0 1 .416-.672A1.5 1.5 0 0 0 11 4Zm-5.5 1.5a2 2 0 1 0 0 4 2 2 0 0 0 0-4ZM9.5 6a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Z"></path>'.html_safe
    when 'tag'
      '<path d="M2.5 7.775V2.75a.25.25 0 0 1 .25-.25h5.025a.25.25 0 0 1 .177.073l6.25 6.25a.25.25 0 0 1 0 .354l-5.025 5.025a.25.25 0 0 1-.354 0l-6.25-6.25a.25.25 0 0 1-.073-.177Zm-1.5 0V2.75C1 1.784 1.784 1 2.75 1h5.025c.464 0 .909.184 1.237.513l6.25 6.25a1.75 1.75 0 0 1 0 2.474l-5.026 5.026a1.75 1.75 0 0 1-2.474 0l-6.25-6.25A1.75 1.75 0 0 1 1 7.775Z M6 5a1 1 0 1 1 0-2 1 1 0 0 1 0 2Z"></path>'.html_safe
    when 'scenario'
      '<path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"></path><path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.319-.094a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"></path>'.html_safe
    else
      '<path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"></path><path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.319-.094a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"></path>'.html_safe
    end
  end

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
        href: helpers.document_path(resource)
      }
    ]

    if can_edit?
      items += [
        {
          label: "Edit",
          icon: :pencil,
          href: helpers.edit_document_path(resource)
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
        href: helpers.user_path(resource)
      }
    ]

    if can_edit?
      items << {
        label: "Edit",
        icon: :pencil,
        href: helpers.edit_user_path(resource)
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
        href: helpers.organization_path(resource)
      }
    ]

    if can_edit?
      items << {
        label: "Edit",
        icon: :pencil,
        href: helpers.edit_organization_path(resource)
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
        href: helpers.folder_path(resource)
      }
    ]

    if can_edit?
      items << {
        label: "Edit",
        icon: :pencil,
        href: helpers.edit_folder_path(resource)
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
        href: helpers.team_path(resource)
      }
    ]

    if can_edit?
      items << {
        label: "Edit",
        icon: :pencil,
        href: helpers.edit_team_path(resource)
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
        href: helpers.scenario_path(resource)
      }
    ]

    if can_edit?
      items << {
        label: "Edit",
        icon: :pencil,
        href: helpers.edit_scenario_path(resource)
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
