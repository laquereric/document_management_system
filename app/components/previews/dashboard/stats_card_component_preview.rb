class User::Dashboard::StatsCardComponentPreview < ViewComponent::Preview
  def default
    render(User::Dashboard::StatsCardComponent.new(
      title: "Total Documents",
      value: 42,
      icon: "file-text",
      color: "primary"
    ))
  end

  def success
    render(User::Dashboard::StatsCardComponent.new(
      title: "Active Teams",
      value: 8,
      icon: "people",
      color: "success"
    ))
  end

  def warning
    render(User::Dashboard::StatsCardComponent.new(
      title: "Pending Reviews",
      value: 15,
      icon: "clock",
      color: "warning"
    ))
  end

  def info
    render(User::Dashboard::StatsCardComponent.new(
      title: "Teams Led",
      value: 3,
      icon: "person-badge",
      color: "info"
    ))
  end
end
