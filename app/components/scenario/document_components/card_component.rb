# Document card component for displaying documents in lists

class User::DocumentComponents::CardComponent < Layout::CardComponent

  def initialize(document:, show_actions: true, **system_arguments)
    @document = document
    initialize_card_base(show_actions: show_actions, **system_arguments)
  end

  private

  attr_reader :document

  def card_classes
    "#{condensed_card_classes} document-card #{system_arguments[:class]}".strip
  end

  def truncated_content
    super(document.content)
  end

  def formatted_date
    super(document.created_at)
  end

  def author_name
    super(document.author)
  end

  def folder_name
    super(document.folder)
  end

  def team_name
    super(document.team)
  end

  def organization_name
    super(document.organization)
  end

  def has_file?
    document.file.attached? && document.file.present?
  end

  def file_extension
    return nil unless has_file?
    filename = document.file.filename.to_s
    filename.split('.').last&.upcase
  end

  def file_icon
    return "file" unless has_file?
    
    extension = file_extension&.downcase
    case extension
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

  # Context methods for the template
  def template_context
    {
      card_classes: card_classes,
      truncated_content: truncated_content,
      formatted_date: formatted_date,
      author_name: author_name,
      folder_name: folder_name,
      team_name: team_name,
      organization_name: organization_name,
      has_file?: has_file?,
      file_extension: file_extension,
      file_icon: file_icon,
      document: document,
      document_path: method(:document_path),
      edit_document_path: method(:edit_document_path),
      rails_blob_path: method(:rails_blob_path),
      button_to: method(:button_to),
      link_to: method(:link_to),
      render: method(:render)
    }
  end
end
