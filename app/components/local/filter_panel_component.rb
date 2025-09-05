class Primer::FilterPanelComponent < ApplicationComponent
  def initialize(
    title: "Filters",
    collapsible: true,
    collapsed: false,
    **system_arguments
  )
    @title = title
    @collapsible = collapsible
    @collapsed = collapsed
    @system_arguments = deny_tag_argument(**system_arguments)
    @system_arguments[:tag] = :div
    @system_arguments[:classes] = class_names(
      "mb-4",
      system_arguments[:classes]
    )
  end

  private

  attr_reader :title, :collapsible, :collapsed

  def render_panel
    render(Primer::CardComponent.new) do
      safe_join([
        render_header,
        render_body
      ])
    end
  end

  def render_header
    render(Primer::BorderBox::Header.new) do
      if collapsible
        render_collapsible_header
      else
        render_static_header
      end
    end
  end

  def render_collapsible_header
    render(Primer::BaseComponent.new(
      tag: :button,
      type: "button",
      classes: "btn-link border-0 bg-transparent p-0 d-flex flex-items-center flex-justify-between width-full",
      data: {
        toggle: "collapse",
        target: "#filter-panel-body"
      },
      "aria-expanded": !collapsed,
      "aria-controls": "filter-panel-body"
    )) do
      safe_join([
        content_tag(:h3, title, class: "f5 text-semibold"),
        render_collapse_icon
      ])
    end
  end

  def render_static_header
    content_tag(:h3, title, class: "f5 text-semibold")
  end

  def render_collapse_icon
    render(Primer::Beta::Octicon.new(
      icon: collapsed ? :chevron_down : :chevron_up,
      size: :small
    ))
  end

  def render_body
    render(Primer::BorderBox::Body.new(
      id: "filter-panel-body",
      classes: class_names(
        "collapse",
        "show": !collapsed
      )
    )) do
      content
    end
  end
end
