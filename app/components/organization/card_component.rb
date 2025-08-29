class Organization::CardComponent < ApplicationComponent
  include CardConcerns

  def initialize(organization:, show_actions: true, **system_arguments)
    @organization = organization
    initialize_card_base(show_actions: show_actions, **system_arguments)
  end

  private

  attr_reader :organization

  def card_classes
    "#{condensed_card_classes} h-full #{system_arguments[:class]}".strip
  end

  def title_classes
    "#{header_classes} border-bottom-0 pb-2"
  end

  def body_classes
    "#{super} pt-0 pb-3"
  end

  def footer_classes
    "#{super} border-top pt-3"
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
end
