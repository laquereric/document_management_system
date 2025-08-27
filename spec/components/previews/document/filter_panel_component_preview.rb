class Document::FilterPanelComponentPreview < ViewComponent::Preview
  def default
    render(Document::FilterPanelComponent.new)
  end

  def with_search_params
    # Simulate a search object with some filters applied
    search = OpenStruct.new(
      status_eq: "active",
      folder_id_eq: "1",
      tags_id_in: ["1", "2"]
    )
    
    render(Document::FilterPanelComponent.new(search: search))
  end
end
