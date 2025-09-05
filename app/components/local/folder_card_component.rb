class Local::FolderCardComponent < ApplicationComponent
  def initialize(
    folder:,
    show_actions: true,
    **system_arguments
  )
    @folder = folder
    @show_actions = show_actions
    @system_arguments = system_arguments
  end

  private

  attr_reader :folder, :show_actions

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
        render_folder_icon,
        render_title_and_stats
      ])
    end
  end

  def render_folder_icon
    content_tag(:div, class: "mr-3") do
      render(Primer::Beta::Octicon.new(
        icon: :file_directory,
        color: :fg_accent,
        size: :medium
      ))
    end
  end

  def render_title_and_stats
    content_tag(:div, class: "flex-1") do
      safe_join([
        render_title,
        render_document_count
      ])
    end
  end

  def render_title
    content_tag(:h4, class: "f4 text-semibold mb-1") do
      link_to(
        folder.name,
        folder_path(folder),
        class: "Link--primary"
      )
    end
  end

  def render_document_count
    render(Primer::Beta::Counter.new) do
      "#{document_count} documents"
    end
  end

  def render_actions_section
    return unless show_actions

    render(Layout::Card::ActionsMenuComponent.new(
      resource: folder,
      resource_type: 'folder'
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
    return unless folder.description.present?

    content_tag(:p, class: "f5 color-fg-muted mb-3 lh-default") do
      truncate(folder.description, length: 150)
    end
  end

  def render_metadata_section
    content_tag(:div, class: "d-flex flex-column gap-2") do
      safe_join([
        render_metadata_item("Parent", parent_name),
        render_metadata_item("Created", formatted_date),
        render_metadata_item("Documents", document_count.to_s)
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
  def document_count
    @document_count ||= folder.documents.count
  end

  def parent_name
    folder.parent&.name || "Root"
  end

  def formatted_date
    folder.created_at.strftime("%B %d, %Y")
  end

  def folder_path(folder)
    Rails.application.routes.url_helpers.models_folder_path(folder)
  end
end
