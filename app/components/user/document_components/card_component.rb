# Document card component for displaying documents in user context

class User::DocumentComponents::CardComponent < ApplicationComponent
  def initialize(document:, show_actions: true, **system_arguments)
    @document = document
    @show_actions = show_actions
    @system_arguments = system_arguments
  end

  def card_classes
    "Box p-3 mb-3 #{system_arguments[:class]}".strip
  end

  def title_classes
    "h4 mb-2"
  end

  def content_classes
    "color-fg-muted mb-3"
  end

  def meta_classes
    "color-fg-muted f6"
  end

  def action_classes
    "d-flex justify-content-between align-items-center"
  end

  def truncated_title
    return "" unless document.title.present?
    title = document.title.to_s
    title.length > 50 ? "#{title[0..46]}..." : title
  end

  def truncated_content
    return "" unless document.content.present?
    content = document.content.to_s
    content.length > 100 ? "#{content[0..96]}..." : content
  end

  def formatted_date
    return "Unknown date" unless document.created_at.present?
    document.created_at.strftime("%B %d, %Y")
  end

  def file_extension
    return nil unless document.file.attached? && document.file.present?
    filename = document.file.filename.to_s
    parts = filename.split(".")
    parts.length > 1 ? parts.last.downcase : nil
  end

  def file_icon
    return "file-text" unless document.file.attached? && document.file.present?

    extension = file_extension
    case extension
    when "pdf"
      "file-pdf"
    when "jpg", "jpeg", "png", "gif", "svg"
      "file-media"
    when "doc", "docx", "txt", "rtf"
      "file-text"
    when "xls", "xlsx"
      "file-spreadsheet"
    when "ppt", "pptx"
      "file-presentation"
    else
      "file-text"
    end
  end

  # Context methods for the template
  def template_context
    {
      card_classes: method(:card_classes),
      title_classes: method(:title_classes),
      content_classes: method(:content_classes),
      meta_classes: method(:meta_classes),
      action_classes: method(:action_classes),
      truncated_title: method(:truncated_title),
      truncated_content: method(:truncated_content),
      formatted_date: method(:formatted_date),
      file_extension: method(:file_extension),
      file_icon: method(:file_icon),
      document: document,
      document_path: method(:document_path),
      edit_document_path: method(:edit_document_path),
      rails_blob_path: method(:rails_blob_path),
      button_to: method(:button_to),
      link_to: method(:link_to),
      render: method(:render)
    }
  end

  private

  attr_reader :document, :show_actions, :system_arguments
end
