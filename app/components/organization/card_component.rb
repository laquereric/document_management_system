class Organization::CardComponent < Layout::CardComponent

  def initialize(organization:, show_actions: true, admin_context: false, **system_arguments)
    @organization = organization
    @admin_context = admin_context
    super(show_actions: show_actions, **system_arguments)
  end

  private

  attr_reader :organization, :admin_context

  def card_classes
    "#{condensed_card_classes} h-full #{system_arguments[:class]}".strip
  end

  def truncated_description
    super(organization.description)
  end

  def formatted_date
    super(organization.created_at)
  end

  def organization_name
    safe_name(organization, "Unknown organization")
  end

  def admin_context?
    admin_context
  end
end

