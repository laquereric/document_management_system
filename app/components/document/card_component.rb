# Document card component for displaying documents in lists

class Document::CardComponent < ApplicationComponent
  def initialize(document:, show_actions: true, **system_arguments)
    @document = document
    @show_actions = show_actions
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :document, :show_actions, :system_arguments

  def card_classes
    "Box Box--condensed #{system_arguments[:class]}"
  end

  def title_classes
    "Box-title"
  end

  def content_classes
    "Box-body"
  end

  def footer_classes
    "Box-footer"
  end

  def truncated_content
    content = document.content || ""
    content.length > 150 ? "#{content[0..150]}..." : content
  end

  def formatted_date
    document.created_at&.strftime("%b %d, %Y") || "Unknown date"
  end

  def author_name
    document.author&.name || "Unknown author"
  end

  def folder_name
    document.folder&.name || "Unknown folder"
  end

  def team_name
    document.team&.name || "Unknown team"
  end

  def organization_name
    document.organization&.name || "Unknown organization"
  end

  def has_file?
    document.file.attached?
  end

  def file_icon
    case document.file.filename.extension.downcase
    when "pdf"
      "file-pdf"
    when "doc", "docx"
      "file-word"
    when "xls", "xlsx"
      "file-spreadsheet"
    when "ppt", "pptx"
      "file-presentation"
    when "txt", "rtf"
      "file-text"
    else
      "file"
    end
  end
end
