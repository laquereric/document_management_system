class Models::Documents::CardComponent < Layout::Card::CardComponent
  def initialize(document:, show_actions: true, **system_arguments)
    @document = document
    super(show_actions: show_actions, **system_arguments)
  end

  private

  attr_reader :document

  def card_classes
    "Box p-3 document-card"
  end

  def document_icon
    document.file.attached? ? file_type_icon : "file"
  end

  def file_type_icon
    return "file" unless document.file.attached?
    
    extension = document.file.filename.extension.downcase
    
    case extension
    when "pdf" then "file-pdf"
    when "doc", "docx" then "file-text"
    when "xls", "xlsx" then "table"
    when "ppt", "pptx" then "device-desktop"
    when "txt", "rtf" then "file-text"
    else "file"
    end
  end

  def file_extension
    return nil unless document.file.attached?
    document.file.filename.extension.upcase
  end

  def truncated_content
    return nil unless document.content.present?
    content = strip_tags(document.content)
    content.length > 120 ? "#{content[0..120]}..." : content
  end
end
