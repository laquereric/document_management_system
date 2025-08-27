# Document card component for displaying documents in lists

class Document::CardComponent < ApplicationComponent
  LAYOUT_VARIANTS = %i[list grid compact].freeze
  STATUS_COLORS = {
    "draft" => :attention,
    "review" => :accent,
    "approved" => :success,
    "archived" => :subtle
  }.freeze

  def initialize(
    document:,
    layout: :list,
    show_actions: true,
    show_metadata: true,
    **system_arguments
  )
    @document = document
    @layout = fetch_or_fallback(LAYOUT_VARIANTS, layout, :list)
    @show_actions = show_actions
    @show_metadata = show_metadata
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :document, :layout, :show_actions, :show_metadata, :system_arguments

  def card_classes
    base_classes = ["Box", "Box--condensed"]
    case layout
    when :grid
      base_classes << "d-flex flex-column height-full"
    when :compact
      base_classes << "Box--tight"
    end
    base_classes.join(" ")
  end

  def status_color
    STATUS_COLORS[document.status&.name&.downcase] || :subtle
  end

  def file_icon
    return :"file-text" unless document.file.attached?
    
    content_type = document.file.content_type
    case content_type
    when /image/
      :"file-media"
    when /pdf/
      :"file-binary"
    when /word|doc/
      :"file-text"
    when /excel|spreadsheet/
      :"file-binary"
    when /powerpoint|presentation/
      :"file-binary"
    when /zip|archive/
      :"file-zip"
    when /text/
      :"file-text"
    else
      :file
    end
  end

  def formatted_file_size
    return "" unless document.file.attached?
    
    bytes = document.file.byte_size
    units = %w[B KB MB GB]
    size = bytes.to_f
    unit_index = 0
    
    while size >= 1024 && unit_index < units.length - 1
      size /= 1024
      unit_index += 1
    end
    
    "#{size.round(1)} #{units[unit_index]}"
  end

  def time_ago_text
    time_ago_in_words(document.updated_at)
  end
end
