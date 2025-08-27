class Organization::CardComponent < ApplicationComponent
  def initialize(organization:, show_actions: true, **system_arguments)
    @organization = organization
    @show_actions = show_actions
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :organization, :show_actions, :system_arguments

  def card_classes
    "Box Box--condensed #{system_arguments[:class]}"
  end

  def title_classes
    "Box-title"
  end

  def content_classes
    "Box-body"
  end

  def footer_classes
    "Box-footer"
  end

  def truncated_description
    description = organization.description || ""
    description.length > 150 ? "#{description[0..150]}..." : description
  end

  def formatted_date
    organization.created_at&.strftime("%b %d, %Y") || "Unknown date"
  end
end
