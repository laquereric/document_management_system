# Document card component for displaying documents in lists

class Document::CardComponent < Organization::CardComponent

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
end
