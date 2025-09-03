# Sidebar navigation component

class Layout::Navigation::SidebarComponent < ApplicationComponent
  VARIANT_OPTIONS = %i[default collapsed].freeze

  def initialize(controller_name: nil, current_user: nil, variant: :default, **system_arguments)
    @controller_name = controller_name
    @current_user = current_user
    @variant = fetch_or_fallback(VARIANT_OPTIONS, variant, :default)
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :current_user, :variant, :system_arguments

  def navigation_items
    []
  end

  def user_navigation_items
    return [] unless current_user
    [
      {
        label: "Dashboard",
        icon: "home",
        path: dashboard_index_path,
        active: current_page?(dashboard_index_path)
      },
      {
        label: "Documents",
        icon: "file-text",
        path: models_documents_path,
        active: @controller_name == "documents"
      },
      {
        label: "Folders",
        icon: "file-directory",
        path: models_folders_path,
        active: @controller_name == "folders"
      },
      {
        label: "Tags",
        icon: "tag",
        path: models_tags_path,
        active: @controller_name == "tags"
      },
      {
        label: "Activity",
        icon: "pulse",
        path: models_activities_path,
        active: @controller_name == "activities"
      },
      {
        label: "Teams",
        icon: "people",
        path: models_teams_path,
        active: @controller_name == "teams"
      },
      {
        label: "Tags",
        icon: "tag",
        path: models_tags_path,
        active: @controller_name == "tags"
      },
      {
        label: "Organizations",
        icon: "organization",
        path: models_organizations_path,
        active: @controller_name == "organizations"
      },
      {
        label: "Profile",
        icon: "person",
        path: models_user_path(current_user),
        active: @controller_name == "users" && action_name == "show"
      }
    ]
  end

  def admin_navigation_items
    return [] unless current_user&.admin?
    [
      {
        label: "Dashboard",
        icon: "gear",
        path: dashboard_admin_path,
        active: @controller_name.starts_with?("admin")
      },
      {
        label: "Organizations",
        icon: "organization",
        path: models_organizations_path,
        active: @controller_name == "organizations"
      },
      {
        label: "Users",
        icon: "people",
        path: models_users_path,
        active: @controller_name == "users"
      },
      {
        label: "Teams",
        icon: "group",
        path: models_teams_path,
        active: @controller_name == "teams"
      },
      {
        label: "Scenarios",
        icon: "list-unordered",
        path: models_scenarios_path,
        active: @controller_name == "scenarios"
      },
      {
        label: "Tags",
        icon: "tag",
        path: models_tags_path,
        active: @controller_name == "tags"
      }
    ]
  end

  def render_icon_path(icon)
    case icon
    when 'home'
      '<path d="M6.906.664a1.749 1.749 0 0 1 2.187 0l5.25 4.2c.415.332.657.835.657 1.367v7.019A1.75 1.75 0 0 1 13.25 15h-3.5a.75.75 0 0 1-.75-.75V9H7v5.25a.75.75 0 0 1-.75.75h-3.5A1.75 1.75 0 0 1 1 13.25V6.23c0-.531.242-1.034.657-1.366l5.25-4.2Zm1.25 1.171a.25.25 0 0 0-.312 0l-5.25 4.2a.25.25 0 0 0-.094.196v7.019c0 .138.112.25.25.25H5.5V8.25a.75.75 0 0 1 .75-.75h3.5a.75.75 0 0 1 .75.75v5.25H13a.25.25 0 0 0 .25-.25V6.23a.25.25 0 0 0-.094-.195Z"></path>'.html_safe
    when 'file-text'
      '<path d="M2 1.75C2 .784 2.784 0 3.75 0h6.586c.464 0 .909.184 1.237.513l2.914 2.914c.329.328.513.773.513 1.237v9.586A1.75 1.75 0 0 1 13.25 16h-9.5A1.75 1.75 0 0 1 2 14.25Zm1.75-.25a.25.25 0 0 0-.25.25v12.5c0 .138.112.25.25.25h9.5a.25.25 0 0 0 .25-.25V6H9.75A1.75 1.75 0 0 1 8 4.25V1.5Zm6.75.062V4.25c0 .138.112.25.25.25h2.688l-.011-.013-2.914-2.914-.013-.011Z"></path>'.html_safe
    when 'file-directory'
      '<path d="M1.75 1A1.75 1.75 0 0 0 0 2.75v10.5C0 14.216.784 15 1.75 15h12.5A1.75 1.75 0 0 0 16 13.25v-8.5A1.75 1.75 0 0 0 14.25 3H7.5a.25.25 0 0 1-.2-.1l-.9-1.2C6.07 1.26 5.55 1 5 1H1.75Z"></path>'.html_safe
    when 'tag'
      '<path d="M2.5 7.775V2.75a.25.25 0 0 1 .25-.25h5.025a.25.25 0 0 1 .177.073l6.25 6.25a.25.25 0 0 1 0 .354l-5.025 5.025a.25.25 0 0 1-.354 0l-6.25-6.25a.25.25 0 0 1-.073-.177Zm-1.5 0V2.75C1 1.784 1.784 1 2.75 1h5.025c.464 0 .909.184 1.237.513l6.25 6.25a1.75 1.75 0 0 1 0 2.474l-5.026 5.026a1.75 1.75 0 0 1-2.474 0l-6.25-6.25A1.75 1.75 0 0 1 1 7.775Z M6 5a1 1 0 1 1 0-2 1 1 0 0 1 0 2Z"></path>'.html_safe
    when 'pulse'
      '<path d="M6 2c.306 0 .582.187.696.471L10 10.731l1.304-3.26A.751.751 0 0 1 12 7h3.25a.75.75 0 0 1 0 1.5h-2.742l-1.812 4.528a.751.751 0 0 1-1.392 0L6 4.77 4.696 8.03A.75.75 0 0 1 4 8.75H.75a.75.75 0 0 1 0-1.5h2.742l1.812-4.529A.751.751 0 0 1 6 2Z"></path>'.html_safe
    when 'person'
      '<path d="M10.561 8.073a6.005 6.005 0 0 1 3.432 5.142.75.75 0 1 1-1.498.07 4.5 4.5 0 0 0-8.99 0 .75.75 0 0 1-1.498-.07 6.004 6.004 0 0 1 3.431-5.142 3.999 3.999 0 1 1 5.123 0ZM10.5 5a2.5 2.5 0 1 0-5 0 2.5 2.5 0 0 0 5 0Z"></path>'.html_safe
    when 'gear'
      '<path d="M8 0a8.2 8.2 0 0 1 .701.031C9.444.095 9.99.645 10.16 1.29l.288 1.107c.018.066.079.158.212.218.906.405 1.678.961 2.26 1.543.134.134.348.134.482 0l.696-.696c.441-.441 1.057-.441 1.498 0s.441 1.057 0 1.498l-.696.696c-.134.134-.134.348 0 .482.582.582 1.138 1.354 1.543 2.26.06.133.152.194.218.212l1.107.288c.645.17 1.195.716 1.26 1.459C15.969 7.724 16 7.862 16 8s-.031.276-.069.701c-.065.743-.615 1.289-1.26 1.459l-1.107.288c-.066.018-.158.079-.218.212-.405.906-.961 1.678-1.543 2.26-.134.134-.134.348 0 .482l.696.696c.441.441.441 1.057 0 1.498s-1.057.441-1.498 0l-.696-.696c-.134-.134-.348-.134-.482 0-.582.582-1.354 1.138-2.26 1.543-.133.06-.194.152-.212.218l-.288 1.107c-.17.645-.716 1.195-1.459 1.26C8.276 15.969 8.138 16 8 16s-.276-.031-.701-.069c-.743-.065-1.289-.615-1.459-1.26l-.288-1.107c-.018-.066-.079-.158-.212-.218-.906-.405-1.678-.961-2.26-1.543-.134-.134-.348-.134-.482 0l-.696.696c-.441.441-1.057.441-1.498 0s-.441-1.057 0-1.498l.696-.696c.134-.134.134-.348 0-.482-.582-.582-1.138-1.354-1.543-2.26-.06-.133-.152-.194-.218-.212L.569 9.701C-.076 9.531-.626 8.985-.691 8.242 0.031 8.276 0 8.138 0 8s.031-.276.069-.701c.065-.743.615-1.289 1.26-1.459l1.107-.288c.066-.018.158-.079.218-.212.405-.906.961-1.678 1.543-2.26.134-.134.134-.348 0-.482L3.501 2.002c-.441-.441-.441-1.057 0-1.498s1.057-.441 1.498 0l.696.696c.134.134.348.134.482 0 .582-.582 1.354-1.138 2.26-1.543.133-.06.194-.152.212-.218L8.84.569c.17-.645.716-1.195 1.459-1.26C7.724.031 7.862 0 8 0ZM8 1.5a6.5 6.5 0 1 0 0 13 6.5 6.5 0 0 0 0-13Zm0 2a4.5 4.5 0 1 1 0 9 4.5 4.5 0 0 1 0-9Z"></path>'.html_safe
    when 'organization'
      '<path d="M1.5 14.25c0 .138.112.25.25.25H4v-1.25a.75.75 0 0 1 1.5 0v1.25h2.5v-1.25a.75.75 0 0 1 1.5 0v1.25h2.25a.25.25 0 0 0 .25-.25V1.75a.25.25 0 0 0-.25-.25h-8.5a.25.25 0 0 0-.25.25v12.5ZM1.75 16A1.75 1.75 0 0 1 0 14.25V1.75C0 .784.784 0 1.75 0h8.5C11.216 0 12 .784 12 1.75v12.5c0 .966-.784 1.75-1.75 1.75h-8.5ZM4 1.75A.25.25 0 0 1 4.25 1.5h3.5a.25.25 0 0 1 .25.25v3.5a.25.25 0 0 1-.25.25h-3.5A.25.25 0 0 1 4 5.25v-3.5ZM4.25 1a.75.75 0 0 0-.75.75v3.5c0 .414.336.75.75.75h3.5a.75.75 0 0 0 .75-.75v-3.5a.75.75 0 0 0-.75-.75h-3.5ZM6 10.75A.75.75 0 0 1 6.75 10h3.5a.75.75 0 0 1 0 1.5h-3.5A.75.75 0 0 1 6 10.75ZM6.75 9a.75.75 0 0 0 0 1.5h3.5a.75.75 0 0 0 0-1.5h-3.5ZM6 6.75A.75.75 0 0 1 6.75 6h3.5a.75.75 0 0 1 0 1.5h-3.5A.75.75 0 0 1 6 6.75ZM6.75 5a.75.75 0 0 0 0 1.5h3.5a.75.75 0 0 0 0-1.5h-3.5Z"></path>'.html_safe
    when 'people'
      '<path d="M2 5.5a3.5 3.5 0 1 1 5.898 2.549 5.508 5.508 0 0 1 3.034 4.084.75.75 0 1 1-1.482.235 4.001 4.001 0 0 0-7.9 0 .75.75 0 0 1-1.482-.236A5.507 5.507 0 0 1 3.102 8.05 3.493 3.493 0 0 1 2 5.5ZM11 4a3.001 3.001 0 0 1 2.22 5.018 5.01 5.01 0 0 1 2.56 3.012.749.749 0 0 1-.885.954.752.752 0 0 1-.665-.57 3.51 3.51 0 0 0-2.522-2.372.75.75 0 0 1-.574-.73v-.352a.75.75 0 0 1 .416-.672A1.5 1.5 0 0 0 11 4Zm-5.5 1.5a2 2 0 1 0 0 4 2 2 0 0 0 0-4ZM9.5 6a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Z"></path>'.html_safe
    when 'group'
      '<path d="M2 5.5a3.5 3.5 0 1 1 5.898 2.549 5.508 5.508 0 0 1 3.034 4.084.75.75 0 1 1-1.482.235 4.001 4.001 0 0 0-7.9 0 .75.75 0 0 1-1.482-.236A5.507 5.507 0 0 1 3.102 8.05 3.493 3.493 0 0 1 2 5.5ZM11 4a3.001 3.001 0 0 1 2.22 5.018 5.01 5.01 0 0 1 2.56 3.012.749.749 0 0 1-.885.954.752.752 0 0 1-.665-.57 3.51 3.51 0 0 0-2.522-2.372.75.75 0 0 1-.574-.73v-.352a.75.75 0 0 1 .416-.672A1.5 1.5 0 0 0 11 4Zm-5.5 1.5a2 2 0 1 0 0 4 2 2 0 0 0 0-4ZM9.5 6a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Z"></path>'.html_safe
    when 'list-unordered'
      '<path d="M5.75 2.5h8.5a.75.75 0 0 1 0 1.5h-8.5a.75.75 0 0 1 0-1.5Zm0 5h8.5a.75.75 0 0 1 0 1.5h-8.5a.75.75 0 0 1 0-1.5Zm0 5h8.5a.75.75 0 0 1 0 1.5h-8.5a.75.75 0 0 1 0-1.5ZM2 14a1 1 0 1 1 0-2 1 1 0 0 1 0 2Zm1-6a1 1 0 1 1-2 0 1 1 0 0 1 2 0ZM2 4a1 1 0 1 1 0-2 1 1 0 0 1 0 2Z"></path>'.html_safe
    else
      '<path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"></path><path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"></path>'.html_safe
    end
  end

  # Context methods for the template
  def template_context
    {
      user_navigation_items: user_navigation_items,
      admin_navigation_items: admin_navigation_items,
      render_icon_path: method(:render_icon_path),
      current_user: current_user,
      controller_name: @controller_name,
      variant: variant,
      current_page?: method(:current_page?),
      action_name: action_name,
      dashboard_index_path: dashboard_index_path,
      documents_path: models_documents_path,
      folders_path: models_folders_path,
      tags_path: models_tags_path,
      user_activities_path: method(:models_activities_path),
      user_teams_path: method(:models_teams_path),
      user_tags_path: method(:models_tags_path),
      user_organizations_path: method(:models_organizations_path),
      user_path: method(:user_path),
      admin_root_path: dashboard_admin_path,
      organizations_path: models_organizations_path
    }
  end
end
