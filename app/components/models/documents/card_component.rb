# Document card component for displaying documents in lists

class Models::Documents::CardComponent < Layout::Card::CardComponent

  def initialize(document:, show_actions: true, **system_arguments)
    @document = document
    @system_arguments = merge_system_arguments(system_arguments)
    super(show_actions: show_actions)
  end

  def card_classes
    "#{condensed_card_classes} document-card #{system_arguments[:class]}".strip
  end

  def condensed_card_classes
    "Box p-3"
  end

  def truncated_content
    return "" unless document.content.present?
    document.content.length > 100 ? "#{document.content[0..100]}..." : document.content
  end

  def formatted_date
    return "" unless document.created_at.present?
    document.created_at.strftime("%B %d, %Y")
  end

  def author_name
    return "" unless document.author.present?
    document.author.respond_to?(:name) ? document.author.name : document.author.to_s
  end

  def folder_name
    return "" unless document.folder.present?
    document.folder.respond_to?(:name) ? document.folder.name : document.folder.to_s
  end

  def team_name
    return "" unless document.team.present?
    document.team.respond_to?(:name) ? document.team.name : document.team.to_s
  end

  def organization_name
    return "" unless document.organization.present?
    document.organization.respond_to?(:name) ? document.organization.name : document.organization.to_s
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

  private

  attr_reader :document, :system_arguments
end
