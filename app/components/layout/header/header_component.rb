class Layout::Header::HeaderComponent < ApplicationComponent
  def initialize(
    current_user: nil,
    title: nil,
    full: true,
    **system_arguments
  )
    @current_user = current_user
    @title = title
    @full = full
    @system_arguments = system_arguments.dup
  end

  private

  attr_reader :current_user, :title, :full

  def render_header
    render(Primer::BaseComponent.new(
      tag: :header,
      classes: "d-flex flex-items-center flex-justify-between p-3 border-bottom color-bg-default"
    )) do
      safe_join([
        render_brand_section,
        render_search_section,
        render_actions_section
      ])
    end
  end

  def render_brand_section
    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "d-flex flex-items-center"
    )) do
      safe_join([
        render_brand_link,
        render_context_breadcrumb
      ].compact)
    end
  end

  def render_brand_link
    render(Primer::Beta::Button.new(
      href: root_path,
      scheme: :invisible,
      size: :medium,
      classes: "p-0"
    )) do
      safe_join([
        render(Primer::Beta::Octicon.new(
          icon: :home,
          mr: 2,
          color: :accent
        )),
        render(Primer::BaseComponent.new(
          tag: :span,
          classes: "f4 text-semibold"
        )) do
          "MagenticMarket.ai"
        end
      ])
    end
  end

  def render_context_breadcrumb
    return unless title

    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "d-none d-lg-flex flex-items-center ml-3"
    )) do
      safe_join([
        render(Primer::Beta::Octicon.new(
          icon: :"chevron-right",
          mr: 1,
          color: :muted
        )),
        render(Primer::BaseComponent.new(
          tag: :span,
          classes: "f5 color-fg-muted"
        )) do
          title
        end
      ])
    end
  end

  def render_search_section
    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "d-none d-md-flex flex-items-center flex-auto mx-3"
    )) do
      render(Layout::Navigation::Search::SearchFormComponent.new(
        name: "search",
        placeholder: "Search documents...",
        size: :medium,
        width: :full
      ))
    end
  end

  def render_actions_section
    render(Primer::Alpha::ActionBar.new) do |component|
      component.with_item_icon_button(
        icon: :search,
        label: "Search",
        classes: "d-md-none",
        "data-toggle": "search"
      )
      
      component.with_item_icon_button(
        icon: :bell,
        label: "Notifications"
      )
      
      component.with_item_icon_button(
        icon: :apps,
        label: "Components",
        href: components_path
      )
      
      component.with_item_divider
      
      if current_user
        component.with_item_icon_button(
          icon: :person,
          label: "User Menu"
        )
      else
        component.with_item_icon_button(
          icon: :person,
          label: "Guest User"
        )
      end
    end
  end

  def render_notification_badge
    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "position-relative"
    )) do
      safe_join([
        render(Primer::Beta::CircleBadge.new(
          variant: :attention,
          size: :small,
          position: :absolute,
          top: -2,
          right: -2
        ))
      ])
    end
  end

  def helpers
    Rails.application.routes.url_helpers
  end

  def root_path
    helpers.root_path
  end

  def components_path
    helpers.components_path
  end

  def new_user_session_path
    helpers.new_user_session_path
  end
end
