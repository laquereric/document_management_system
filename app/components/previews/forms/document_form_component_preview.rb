class Models::Documents::DocumentFormComponentPreview < ViewComponent::Preview
  def new_document
    folder = Folder.first || Folder.new(name: "Sample Folder")
    document = Document.new(folder: folder)

    render(Models::Documents::DocumentFormComponent.new(document: document))
  end

  def edit_document
    document = Document.first || Document.new(
      title: "Sample Document",
      content: "This is sample content for the document.",
      folder: Folder.first || Folder.new(name: "Sample Folder")
    )

    render(Models::Documents::DocumentFormComponent.new(document: document))
  end

  def with_errors
    folder = Folder.first || Folder.new(name: "Sample Folder")
    document = Document.new(folder: folder)
    document.errors.add(:title, "can't be blank")
    document.errors.add(:content, "can't be blank")

    render(Models::Documents::DocumentFormComponent.new(document: document))
  end
end
