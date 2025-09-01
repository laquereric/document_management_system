class User::DocumentComponents::FilterPanelComponentPreview < ViewComponent::Preview
  def default
    render(User::DocumentComponents::FilterPanelComponent.new)
  end

  def with_search_params
    # Simulate a search object with some filters applied
    search = OpenStruct.new(
      status_eq: "active",
      folder_id_eq: "1",
      tags_id_in: ["1", "2"]
    )
    
    render(User::DocumentComponents::FilterPanelComponent.new(search: search))
  end
end
