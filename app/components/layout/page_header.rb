class Layout::PageHeader < ApplicationComponent

  def initialize(
    title:,
    description: nil,
    icon: nil,
    icon_color: "color-fg-accent",
    action: nil,
    variant: :default,
    **system_arguments
  )
    @title = title
    @description = description
    @icon = icon
    @icon_color = icon_color
    @action = action
    @variant = variant
    super(**system_arguments)
  end

  private

  attr_reader :title, :description, :icon, :icon_color, :action, :variant

  def container_classes
    case variant
    when :default
      "d-flex flex-items-center flex-justify-between py-4 border-bottom"
    when :large
      "d-flex flex-column flex-sm-row flex-items-center flex-sm-justify-between mb-6"
    else
      "d-flex flex-items-center flex-justify-between py-4 border-bottom"
    end
  end

  def title_container_classes
    case variant
    when :default
      "d-flex flex-items-center"
    when :large
      "mb-4 mb-sm-0"
    else
      "d-flex flex-items-center"
    end
  end

  def title_classes
    case variant
    when :default
      "f2 lh-condensed text-semibold mb-1"
    when :large
      "h1 mb-2"
    else
      "f2 lh-condensed text-semibold mb-1"
    end
  end

  def description_classes
    case variant
    when :default
      "f5 color-fg-muted mb-0"
    when :large
      "color-fg-muted f4"
    else
      "f5 color-fg-muted mb-0"
    end
  end

  def action_container_classes
    case variant
    when :default
      "d-flex flex-items-center gap-2"
    when :large
      "d-flex flex-items-center gap-3"
    else
      "d-flex flex-items-center gap-2"
    end
  end

  def action_button_classes
    case variant
    when :default
      "btn btn-primary"
    when :large
      "btn btn-primary btn-large"
    else
      "btn btn-primary"
    end
  end

  def icon_classes
    "octicon octicon-#{icon} mr-2 #{icon_color}"
  end

  def icon_size
    case variant
    when :large
      24
    else
      24
    end
  end

  def render_icon?
    icon.present?
  end

  def render_action?
    action.present?
  end

  def render_description?
    description.present?
  end

  def render_icon_svg
    case icon
    when "tag"
      '<path d="M1 7.775V2.75C1 1.784 1.784 1 2.75 1h5.025c.464 0 .91.184 1.238.513l6.25 6.25a1.75 1.75 0 0 1 0 2.474l-5.026 5.026a1.75 1.75 0 0 1-2.474 0l-6.25-6.25A1.752 1.752 0 0 1 1 7.775Zm1.5 0c0 .066.026.13.073.177l6.25 6.25a.25.25 0 0 0 .354 0l5.025-5.025a.25.25 0 0 0 0-.354l-6.25-6.25a.25.25 0 0 0-.177-.073H2.75a.25.25 0 0 0-.25.25ZM6 5a1 1 0 1 1 0 2 1 1 0 0 1 0-2Z"></path>'
    when "file-text"
      '<path d="M2 1.75C2 .784 2.784 0 3.75 0h6.586c.464 0 .909.184 1.237.513l2.914 2.914c.329.328.513.773.513 1.237v9.586A1.75 1.75 0 0 1 13.25 16h-9.5A1.75 1.75 0 0 1 2 14.25Zm1.75-.25a.25.25 0 0 0-.25.25v12.5c0 .138.112.25.25.25h9.5a.25.25 0 0 0 .25-.25V6H9.75A1.75 1.75 0 0 1 8 4.25V1.5Zm6.75.062V4.25c0 .138.112.25.25.25h2.688l-.011-.013-2.914-2.914-.013-.011Z"></path>'
    when "organization"
      '<path d="M1.75 16A1.75 1.75 0 0 1 0 14.25V1.75C0 .784.784 0 1.75 0h8.5C11.216 0 12 .784 12 1.75v12.5c0 .085-.006.168-.018.25h2.268a.25.25 0 0 0 .25-.25V8.285a.25.25 0 0 0-.111-.208l-1.14-.815a.75.75 0 0 1-.375-.65V2.285a.25.25 0 0 0-.25-.25h-1.5a.25.25 0 0 0-.25.25v3.576c0 .055.019.11.055.155.036.044.085.075.14.095l.815.407a.75.75 0 0 1 .375.65v7.285a.25.25 0 0 0 .25.25h.5a.25.25 0 0 0 .25-.25v-5.5a.25.25 0 0 0-.25-.25H12V4.715a.25.25 0 0 0-.111-.208L10.75 3.692a.75.75 0 0 1-.375-.65V1.75a.25.25 0 0 0-.25-.25h-8.5a.25.25 0 0 0-.25.25v12.5c0 .138.112.25.25.25H.25A.25.25 0 0 0 .5 14.25v-3.5a.75.75 0 0 1 1.5 0v3.5c0 .138.112.25.25.25h1.268a.75.75 0 0 1 0 1.5H1.75Z"></path>'
    when "folder"
      '<path d="M1.75 1A1.75 1.75 0 0 0 0 2.75v10.5C0 14.216.784 15 1.75 15h12.5A1.75 1.75 0 0 0 16 13.25v-8.5A1.75 1.75 0 0 0 14.25 3H7.5a.25.25 0 0 1-.2-.1l-.9-1.2C6.07 1.26 5.55 1 5 1H1.75Z"></path>'
    when "users"
      '<path d="M2 5.5a3.5 3.5 0 1 1 5.898 2.549 5.508 5.508 0 0 1 3.034 4.084.75.75 0 1 1-1.482.235 4.001 4.001 0 0 0-7.9 0 .75.75 0 0 1-1.482-.236A5.507 5.507 0 0 1 3.102 8.05 3.493 3.493 0 0 1 2 5.5ZM11 4a3.001 3.001 0 0 1 2.22 5.018 5.01 5.01 0 0 1 2.56 3.012.749.749 0 0 1-.885.954.752.752 0 0 1-.665-.59 3.504 3.504 0 0 0-2.522-2.372.75.75 0 0 1-.574-.73v-.352a.75.75 0 0 1 .416-.672A1.5 1.5 0 0 0 11 4Zm-5.5-.5a2 2 0 1 0-.001 3.999A2 2 0 0 0 5.5 3.5Z"></path>'
    when "gear"
      '<path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"></path><path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"></path>'
    else
      '<path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0ZM1.5 8a6.5 6.5 0 1 0 13 0 6.5 6.5 0 0 0-13 0Z"></path>'
    end.html_safe
  end
end
