class Layout::Dashboard::HeaderComponent < ApplicationComponent
  def initialize(title:, description: nil, icon: nil, badge: nil, **system_arguments)
    @title = title
    @description = description
    @icon = icon
    @badge = badge
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :description, :icon, :badge, :system_arguments

  def header_classes
    "d-flex flex-items-center flex-justify-between py-4 border-bottom #{system_arguments[:class]}"
  end

  def title_classes
    "f2 lh-condensed text-semibold mb-1"
  end

  def description_classes
    "f5 color-fg-muted mb-0"
  end

  def badge_classes
    case badge&.dig(:type)
    when "admin"
      "Label Label--danger"
    when "success"
      "Label Label--success"
    when "warning"
      "Label Label--warning"
    when "info"
      "Label Label--info"
    else
      "Label Label--secondary"
    end
  end

  def render_icon_svg(icon)
    case icon
    when "home"
      '<path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0ZM1.5 8a6.5 6.5 0 1 0 13 0 6.5 6.5 0 0 0-13 0Zm4.879-2.773 4.264 2.559a.25.25 0 0 1 0 .428l-4.264 2.559A.25.25 0 0 1 6 10.559V3.441a.25.25 0 0 1 .379-.214Z"></path>'.html_safe
    when "gear"
      '<path d="M8 0a8.2 8.2 0 0 1 .701.031C9.444.095 9.99.645 10.16 1.29l.288 1.107c.018.066.079.158.212.218.906.405 1.678.961 2.26 1.543.134.134.348.134.482 0l.696-.696c.441-.441 1.057-.441 1.498 0s.441 1.057 0 1.498l-.696.696c-.134.134-.134.348 0 .482.582.582 1.138 1.354 1.543 2.26.06.133.152.194.218.212l1.107.288c.645.17 1.195.716 1.26 1.459C15.969 7.724 16 7.862 16 8s-.031.276-.069.701c-.065.743-.615 1.289-1.26 1.459l-1.107.288c-.066.018-.158.079-.218.212-.405.906-.961 1.678-1.543 2.26-.134.134-.134.348 0 .482l.696.696c.441.441.441 1.057 0 1.498s-1.057.441-1.498 0l-.696-.696c-.134-.134-.348-.134-.482 0-.582.582-1.138-1.354-1.543-2.26-.06-.133-.152-.194-.218-.212L.569 9.701C-.076 9.531-.626 8.985-.691 8.242 0.031 8.276 0 8.138 0 8s.031-.276.069-.701c.065-.743.615-1.289 1.26-1.459l1.107-.288c.066-.018.158-.079.218-.212.405-.906.961-1.678 1.543-2.26.134-.134.134-.348 0-.482L3.501 2.002c-.441-.441-.441-1.057 0-1.498s1.057-.441 1.498 0l.696.696c.134.134.348.134.482 0 .582-.582 1.354-1.138 2.26-1.543.133-.06.194-.152.212-.218L8.84.569c.17-.645.716-1.195 1.459-1.26C7.724.031 7.862 0 8 0ZM8 1.5a6.5 6.5 0 1 0 0 13 6.5 6.5 0 0 0 0-13Zm0 2a4.5 4.5 0 1 1 0 9 4.5 4.5 0 0 1 0-9Z"></path>'.html_safe
    when "shield-check"
      '<path d="M7.467.133a1.748 1.748 0 0 1 1.066 0l5.25 1.68A1.75 1.75 0 0 1 15 3.48V7c0 1.566-.32 3.182-1.303 4.682-.983 1.498-2.585 2.813-5.032 3.855a1.697 1.697 0 0 1-1.33 0c-2.447-1.042-4.049-2.357-5.032-3.855C1.32 10.182 1 8.566 1 7V3.48a1.75 1.75 0 0 1 1.217-1.667l5.25-1.68Zm.61 1.429a.25.25 0 0 0-.153 0l-5.25 1.68a.25.25 0 0 0-.174.238V7c0 1.358.275 2.666 1.057 3.86.784 1.194 2.121 2.267 4.366 3.199a.196.196 0 0 0 .154 0c2.245-.932 3.582-2.005 4.366-3.199C12.725 9.666 13 8.358 13 7V3.48a.251.251 0 0 0-.174-.238l-5.25-1.68ZM11.28 6.28l-4.5 4.5a.75.75 0 0 1-1.06 0l-2-2a.751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018L6.25 9.19l3.97-3.97a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042Z"></path>'.html_safe
    else
      '<path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"></path>'.html_safe
    end
  end

  # Context methods for the template
  def template_context
    {
      header_classes: header_classes,
      title_classes: title_classes,
      description_classes: description_classes,
      badge_classes: badge_classes,
      title: title,
      description: description,
      icon: icon,
      badge: badge,
      render_icon_svg: method(:render_icon_svg)
    }
  end
end
