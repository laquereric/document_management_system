class Models::Documents::FilterPanelComponent < ApplicationComponent
  def initialize(search: nil, **system_arguments)
    @search = search
    super(**system_arguments)
  end

  private

  attr_reader :search

  def status_options
    [
      { label: "All", value: "", active: search&.status_eq.blank? },
      { label: "Active", value: "active", active: search&.status_eq == "active" },
      { label: "Archived", value: "archived", active: search&.status_eq == "archived" },
      { label: "Draft", value: "draft", active: search&.status_eq == "draft" }
    ]
  end

  def tag_options
    Tag.all.map do |tag|
      {
        label: tag.name,
        value: tag.id,
        active: search&.tags_id_in&.include?(tag.id.to_s)
      }
    end
  end

  def folder_options
    Folder.all.map do |folder|
      {
        label: folder.name,
        value: folder.id,
        active: search&.folder_id_eq == folder.id.to_s
      }
    end
  end

  # Context methods for the template
  def template_context
    {
      status_options: status_options,
      tag_options: tag_options,
      folder_options: folder_options,
      search: search,
      render: method(:render),
      form_with: method(:form_with),
      documents_path: documents_path,
      options_for_select: method(:options_for_select),
      link_to: method(:link_to),
      params: params,
      Tag: Tag,
      Folder: Folder,
      Primer: Primer
    }
  end
end
