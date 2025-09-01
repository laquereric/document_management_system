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

  # Context methods for the template
  def template_context
    {
      card_classes: card_classes,
      truncated_description: truncated_description,
      formatted_date: formatted_date,
      organization_name: organization_name,
      admin_context?: admin_context?,
      organization: organization,
      admin_context: admin_context
    }
  end
end

