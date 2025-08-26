# Component preview for Navigation components

class Navigation::ComponentPreview < ViewComponent::Preview
  def header_default
    render(Navigation::HeaderComponent.new(
      current_user: sample_user,
      title: "Document Library"
    ))
  end

  def header_no_user
    render(Navigation::HeaderComponent.new(
      current_user: nil,
      title: "Welcome"
    ))
  end

  def sidebar_default
    render(Navigation::SidebarComponent.new(
      current_user: sample_user,
      variant: :default
    ))
  end

  def sidebar_collapsed
    render(Navigation::SidebarComponent.new(
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
    
    render(Navigation::BreadcrumbComponent.new(breadcrumbs: breadcrumbs))
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
