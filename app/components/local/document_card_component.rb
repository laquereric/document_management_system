class Local::DocumentCardComponent < ApplicationComponent
  def initialize(
    document:,
    show_actions: true,
    **system_arguments
  )
    @document = document
    @show_actions = show_actions
    @system_arguments = system_arguments
  end

  private

  attr_reader :document, :show_actions

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
        render_file_icon,
        render_title_and_label
      ])
    end
  end

  def render_file_icon
    content_tag(:div, class: "mr-3") do
      render(Primer::Beta::Octicon.new(
        icon: :file,
        color: :fg_muted,
        size: :medium
      ))
    end
  end

  def render_title_and_label
    content_tag(:div, class: "flex-1") do
      safe_join([
        render_title,
        render_file_label
      ].compact)
    end
  end

  def render_title
    content_tag(:h4, class: "f4 text-semibold mb-1") do
      link_to(
        document.title,
        document_path(document),
        class: "Link--primary"
      )
    end
  end

  def render_file_label
    return unless has_file?

    render(Primer::Beta::Label.new(scheme: :accent)) do
      safe_join([
        render(Primer::Beta::Octicon.new(icon: :file, mr: 1, size: :small)),
        file_extension
      ])
    end
  end

  def render_actions_section
    return unless show_actions

    render(Layout::Card::ActionsMenuComponent.new(
      resource: document,
      resource_type: 'document'
    ))
  end

  def render_body
    render(Primer::BorderBox::Body.new) do
      safe_join([
        render_content,
        render_tags_section,
        render_metadata_section
      ].compact)
    end
  end

  def render_content
    return unless truncated_content.present?

    content_tag(:p, class: "f5 color-fg-muted mb-3 lh-default") do
      truncated_content
    end
  end

  def render_tags_section
    tags = [document.status, *document.tags].compact
    return unless tags.any?

    content_tag(:div, class: "d-flex flex-items-center flex-wrap gap-2 mb-3") do
      safe_join([
        render_status_badge,
        *render_tag_items
      ].compact)
    end
  end

  def render_status_badge
    return unless document.status

    render(Ui::StatusBadgeComponent.new(status: document.status))
  end

  def render_tag_items
    document.tags.map do |tag|
      render(Models::Tags::TagItemComponent.new(tag: tag))
    end
  end

  def render_metadata_section
    content_tag(:div, class: "d-flex flex-column gap-2") do
      safe_join([
        render_metadata_item("Author", author_name),
        render_metadata_item("Folder", folder_name),
        render_metadata_item("Created", formatted_date)
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

  # Helper methods from original component
  def has_file?
    document.file.attached?
  end

  def file_extension
    return unless has_file?
    
    filename = document.file.filename.to_s
    File.extname(filename).upcase.delete('.')
  end

  def truncated_content
    return unless document.content.present?
    
    content = document.content.truncate(150)
    simple_format(content, {}, wrapper_tag: nil)
  end

  def author_name
    document.user&.name || document.user&.email || "Unknown"
  end

  def folder_name
    document.folder&.name || "Root"
  end

  def formatted_date
    document.created_at.strftime("%B %d, %Y")
  end

  def document_path(document)
    Rails.application.routes.url_helpers.models_document_path(document)
  end
end
