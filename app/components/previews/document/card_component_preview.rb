# Component preview for Document::CardComponent

class User::Document::CardComponentPreview < ViewComponent::Preview
  # @param layout select { choices: [list, grid, compact] } "Layout variant"
  # @param show_actions toggle "Show action menu"
  # @param show_metadata toggle "Show metadata"
  def default(layout: :list, show_actions: true, show_metadata: true)
    render(User::Document::CardComponent.new(
      document: sample_document,
      layout: layout.to_sym,
      show_actions: show_actions,
      show_metadata: show_metadata
    ))
  end

  def grid_layout
    render(User::Document::CardComponent.new(
      document: sample_document,
      layout: :grid
    ))
  end

  def compact_layout
    render(User::Document::CardComponent.new(
      document: sample_document,
      layout: :compact,
      show_metadata: false
    ))
  end

  def with_tags
    document = sample_document
    document.tags = [
      OpenStruct.new(name: "Important"),
      OpenStruct.new(name: "Draft"),
      OpenStruct.new(name: "Review")
    ]
    
    render(User::Document::CardComponent.new(
      document: document,
      layout: :list
    ))
  end

  private

  def sample_document
    OpenStruct.new(
      id: 1,
      title: "Project Requirements Document",
      content: "This is a comprehensive document outlining the project requirements, scope, and deliverables. It includes detailed specifications for each feature and acceptance criteria.",
      author: OpenStruct.new(email: "john.doe@example.com"),
      folder: OpenStruct.new(
        path: "Projects / Web Development / Documentation",
        id: 1
      ),
      status: OpenStruct.new(name: "review"),
      tags: [],
      updated_at: 2.hours.ago,
      file: OpenStruct.new(
        attached?: true,
        content_type: "application/pdf",
        byte_size: 1024000
      )
    )
  end
end
