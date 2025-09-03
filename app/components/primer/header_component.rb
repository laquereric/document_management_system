class Primer::HeaderComponent < ApplicationComponent
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
    @system_arguments[:tag] = :header
    base_classes = ["Header"]
    base_classes << "Header--full" if @full
    base_classes += ["border-bottom", "color-bg-default", "px-3 py-2"]
    base_classes << system_arguments[:classes] if system_arguments[:classes].present?
    
    @system_arguments[:classes] = base_classes.compact.join(" ")
  end

  private

  attr_reader :current_user, :title, :full

  def brand_content
    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "Header-item d-flex flex-items-center"
    )) do
      link_to(
        root_path,
        class: "Header-link d-flex flex-items-center color-fg-default no-underline"
      ) do
        safe_join([
          render(Primer::Beta::Octicon.new(
            icon: :home,
            mr: 2,
            classes: "color-fg-accent",
            size: :medium
          )),
          content_tag(:span, "DocuFlow", class: "f4 text-semibold")
        ])
      end
    end
  end

  def context_section
    return unless title

    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "Header-item d-none d-lg-flex"
    )) do
      content_tag(:span, "/ #{title}", class: "color-fg-muted f5")
    end
  end

  def search_section
    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "Header-item flex-auto d-none d-md-flex mx-3"
    )) do
      render(Primer::SearchInputComponent.new(
        placeholder: "Search documents...",
        size: :medium
      ))
    end
  end

  def actions_section
    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "Header-item d-flex flex-items-center"
    )) do
      safe_join([
        mobile_search_button,
        notifications_button,
        components_link,
        user_section
      ].compact)
    end
  end

  def mobile_search_button
    render(Primer::Beta::Button.new(
      scheme: :invisible,
      size: :small,
      icon: :search,
      mr: 2,
      classes: "d-md-none",
      "aria-label": "Search",
      "data-toggle": "search"
    ))
  end

  def notifications_button
    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "position-relative mr-2"
    )) do
      safe_join([
        render(Primer::Beta::Button.new(
          scheme: :invisible,
          size: :small,
          icon: :bell,
          "aria-label": "Notifications"
        )),
        notification_indicator
      ])
    end
  end

  def notification_indicator
    content_tag(
      :span,
      "",
      class: "notification-indicator position-absolute",
      style: "top: -2px; right: -2px; width: 6px; height: 6px; background-color: var(--bgColor-attention-emphasis); border: 1px solid var(--bgColor-default); border-radius: var(--borderRadius-full);"
    )
  end

  def components_link
    render(Primer::Beta::Button.new(
      href: components_path,
      mr: 2
    )) do
      "Components"
    end
  end

  def user_section
    if current_user
      render(Models::Users::UserMenuComponent.new(user: current_user))
    else
      render(Primer::Beta::Button.new(
        href: new_user_session_path,
        scheme: :primary
      )) do
        "Sign In"
      end
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
