# Component preview for Navigation components

class Layout::Navigation::ComponentPreview < ViewComponent::Preview
  def header_default
    render(Layout::Navigation::HeaderComponent.new(
      current_user: sample_user,
      title: "Document Library"
    ))
  end

  def header_no_user
    render(Layout::Navigation::HeaderComponent.new(
      current_user: nil,
      title: "Welcome"
    ))
  end

  def sidebar_default
    render(Layout::Navigation::SidebarComponent.new(
      current_user: sample_user,
      variant: :default
    ))
  end

  def sidebar_collapsed
    render(Layout::Navigation::SidebarComponent.new(
      current_user: sample_user,
      variant: :collapsed
    ))
  end

  def breadcrumb_deep_path
    breadcrumbs = [
      { label: "Home", path: "/" },
      { label: "Documents", path: "/documents" },
      { label: "Projects", path: "/folders/1" },
      { label: "Web Development", path: "/folders/2" },
      { label: "Current Document", path: nil }
    ]
    
    render(Layout::Navigation::BreadcrumbComponent.new(breadcrumbs: breadcrumbs))
  end

  private

  def sample_user
    OpenStruct.new(
      id: 1,
      email: "user@example.com",
      admin?: false
    )
  end
end
