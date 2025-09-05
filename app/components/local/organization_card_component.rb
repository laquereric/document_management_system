class Local::OrganizationCardComponent < ApplicationComponent
  def initialize(
    organization:,
    show_actions: true,
    **system_arguments
  )
    @organization = organization
    @show_actions = show_actions
    @system_arguments = system_arguments
  end

  private

  attr_reader :organization, :show_actions

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
    content_tag(:div, class: "d-flex flex-items-center") do
      safe_join([
        render_organization_icon,
        render_title_and_stats
      ])
    end
  end

  def render_organization_icon
    content_tag(:div, class: "mr-3") do
      render(Primer::Beta::Octicon.new(
        icon: :organization,
        color: :fg_accent,
        size: :medium
      ))
    end
  end

  def render_title_and_stats
    content_tag(:div, class: "flex-1") do
      safe_join([
        render_title,
        render_member_count
      ])
    end
  end

  def render_title
    content_tag(:h4, class: "f4 text-semibold mb-1") do
      link_to(
        organization.name,
        organization_path(organization),
        class: "Link--primary"
      )
    end
  end

  def render_member_count
    render(Primer::Beta::Counter.new) do
      "#{member_count} members"
    end
  end

  def render_actions_section
    return unless show_actions

    render(Layout::Card::ActionsMenuComponent.new(
      resource: organization,
      resource_type: 'organization'
    ))
  end

  def render_body
    render(Primer::BorderBox::Body.new) do
      safe_join([
        render_description,
        render_metadata_section
      ].compact)
    end
  end

  def render_description
    return unless organization.description.present?

    content_tag(:p, class: "f5 color-fg-muted mb-3 lh-default") do
      truncate(organization.description, length: 150)
    end
  end

  def render_metadata_section
    content_tag(:div, class: "d-flex flex-column gap-2") do
      safe_join([
        render_metadata_item("Type", organization_type),
        render_metadata_item("Created", formatted_date),
        render_metadata_item("Members", member_count.to_s),
        render_metadata_item("Teams", team_count.to_s)
      ])
    end
  end

  def render_metadata_item(label, value)
    render(Primer::BorderBox::Row.new(scheme: :neutral)) do
      content_tag(:div, class: "d-flex flex-items-center flex-justify-between p-2") do
        safe_join([
          content_tag(:span, "#{label}:", class: "f6 color-fg-muted"),
          content_tag(:span, value, class: "f6 text-semibold")
        ])
      end
    end
  end

  # Helper methods
  def member_count
    @member_count ||= organization.users.count
  end

  def team_count
    @team_count ||= organization.teams.count
  end

  def organization_type
    organization.organization_type || "Standard"
  end

  def formatted_date
    organization.created_at.strftime("%B %d, %Y")
  end

  def organization_path(organization)
    Rails.application.routes.url_helpers.models_organization_path(organization)
  end
end
