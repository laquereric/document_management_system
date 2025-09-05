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
    @system_arguments[:tag] = :header
    base_classes = ["Header", "border-bottom", "color-bg-default"]
    base_classes << "Header--full" if @full
    base_classes += ["d-flex", "flex-items-center", "px-3", "py-2"]
    base_classes << system_arguments[:classes] if system_arguments[:classes].present?
    
    @system_arguments[:classes] = base_classes.compact.join(" ")
  end

  private

  attr_reader :current_user, :title, :full

  def brand_content
    render(Local::BaseComponent.new(
      tag: :div,
      classes: "Header-item d-flex flex-items-center"
    )) do
      render(Local::Beta::Button.new(
        href: root_path,
        scheme: :invisible,
        size: :medium,
        classes: "Header-link color-fg-default no-underline p-0"
      )) do
        safe_join([
          render(Local::Beta::Octicon.new(
            icon: :home,
            mr: 2,
            classes: "color-fg-accent"
          )),
          render(Local::BaseComponent.new(
            tag: :span,
            classes: "f4 text-semibold"
          )) do
            "DocuFlow"
          end
        ])
      end
    end
  end

  def context_section
    return unless title

    render(Local::BaseComponent.new(
      tag: :div,
      classes: "Header-item d-none d-lg-flex flex-items-center ml-3"
    )) do
      safe_join([
        render(Local::Beta::Octicon.new(
          icon: :chevron_right,
          mr: 1,
          classes: "color-fg-muted"
        )),
        render(Local::BaseComponent.new(
          tag: :span,
          classes: "color-fg-muted f5 text-semibold"
        )) do
          title
        end
      ])
    end
  end

  def search_section
    render(Local::BaseComponent.new(
      tag: :div,
      classes: "Header-item d-none d-md-flex flex-items-center flex-auto mx-3"
    )) do
      render(Local::SearchInputComponent.new(
        placeholder: "Search documents...",
        size: :medium,
        classes: "width-full"
      ))
    end
  end

  def actions_section
    render(Local::BaseComponent.new(
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
    render(Local::Beta::Button.new(
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
    render(Local::BaseComponent.new(
      tag: :div,
      classes: "position-relative mr-2"
    )) do
      safe_join([
        render(Local::Beta::Button.new(
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
    render(Local::BaseComponent.new(
      tag: :span,
      classes: "CircleBadge CircleBadge--attention position-absolute",
      style: "top: -2px; right: -2px; width: 6px; height: 6px;"
    ))
  end

  def components_link
    render(Local::Beta::Button.new(
      href: components_path,
      scheme: :primary,
      size: :small,
      mr: 2
    )) do
      safe_join([
        render(Local::Beta::Octicon.new(
          icon: :puzzle,
          mr: 1
        )),
        "Components"
      ])
    end
  end

  def user_section
    if current_user
      render(Models::Users::UserMenuComponent.new(user: current_user))
    else
      # In authentication-free environment, show a simple user indicator
      render(Local::BaseComponent.new(
        tag: :div,
        classes: "Header-item d-flex flex-items-center"
      )) do
        render(Local::Beta::Button.new(
          scheme: :invisible,
          size: :small,
          classes: "color-fg-muted"
        )) do
          safe_join([
            render(Local::Beta::Octicon.new(
              icon: :person,
              mr: 1
            )),
            "Guest User"
          ])
        end
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
