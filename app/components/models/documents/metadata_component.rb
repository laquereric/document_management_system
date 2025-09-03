class Models::Documents::MetadataComponent < ApplicationComponent
  def initialize(document:, layout: :vertical, **system_arguments)
    @document = document
    @layout = layout
    @system_arguments = system_arguments
  end

  private

  attr_reader :document, :layout, :system_arguments

  def wrapper_classes
    base_classes = "document-metadata"
    layout_classes = layout == :horizontal ? "d-flex flex-wrap" : "d-flex flex-column"
    gap_classes = layout == :horizontal ? "gap-3" : "gap-2"
    
    "#{base_classes} #{layout_classes} #{gap_classes} #{system_arguments[:class]}".strip
  end

  def metadata_items
    items = [
      {
        icon: "person",
        label: "Author",
        value: document.author&.name || "Unknown",
        url: nil
      },
      {
        icon: "file-directory",
        label: "Folder", 
        value: document.folder&.name || "None",
        url: document.folder ? models_folder_path(document.folder) : nil
      },
      {
        icon: "calendar",
        label: "Created",
        value: document.created_at.strftime("%b %d, %Y"),
        url: nil
      },
      {
        icon: "clock",
        label: "Updated", 
        value: time_ago_in_words(document.updated_at) + " ago",
        url: nil
      }
    ]

    # Add scenario if present
    if document.scenario.present?
      items << {
        icon: "workflow",
        label: "Scenario",
        value: document.scenario.name,
        url: models_scenario_path(document.scenario)
      }
    end

    # Add file info if attached
    if document.file.attached?
      items << {
        icon: "paperclip",
        label: "File",
        value: "#{document.file.filename} (#{number_to_human_size(document.file.byte_size)})",
        url: rails_blob_path(document.file, disposition: "attachment")
      }
    end

    items
  end

  def item_classes
    if layout == :horizontal
      "d-flex flex-items-center gap-2 f6"
    else
      "d-flex flex-items-center flex-justify-between py-2 border-bottom"
    end
  end
end
