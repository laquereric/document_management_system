class Primer::DashboardLayoutComponent < ApplicationComponent
  def initialize(
    title:,
    subtitle: nil,
    actions: nil,
    **system_arguments
  )
    @title = title
    @subtitle = subtitle
    @actions = actions
    @system_arguments = deny_tag_argument(**system_arguments)
    @system_arguments[:tag] = :div
    @system_arguments[:classes] = class_names(
      "container-lg",
      "px-3",
      "py-4",
      system_arguments[:classes]
    )
  end

  private

  attr_reader :title, :subtitle, :actions

  def render_header
    render(Primer::BorderBox::Header.new) do
      content_tag(:div, class: "d-flex flex-items-center flex-justify-between") do
        safe_join([
          render_title_section,
          render_actions_section
        ].compact)
      end
    end
  end

  def render_title_section
    content_tag(:div) do
      safe_join([
        content_tag(:h1, title, class: "f3 text-semibold mb-1"),
        render_subtitle
      ].compact)
    end
  end

  def render_subtitle
    return unless subtitle.present?

    content_tag(:p, subtitle, class: "f5 color-fg-muted")
  end

  def render_actions_section
    return unless actions.present?

    content_tag(:div, class: "d-flex flex-items-center gap-2") do
      actions
    end
  end

  def render_content_section
    render(Primer::BorderBox::Body.new) do
      content
    end
  end
end
