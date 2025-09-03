class Models::Organization::OrganizationFormComponent < ApplicationComponent

  def initialize(organization:, submit_text: "Save Organization", cancel_url: nil, **system_arguments)
    @organization = organization
    @submit_text = submit_text
    @cancel_url = cancel_url
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :organization, :submit_text, :cancel_url, :system_arguments

  def form_classes
    "form #{system_arguments[:class]}"
  end

  def form_url
    if organization.persisted?
      organization_path(organization)
    else
      organizations_path
    end
  end

  def form_method
    organization.persisted? ? :patch : :post
  end

  # Context methods for the template
  def template_context
    {
      form_classes: form_classes,
      form_url: form_url,
      form_method: form_method,
      submit_text: submit_text,
      cancel_url: cancel_url,
      organization: organization,
      organization_path: method(:organization_path),
      organizations_path: models_organizations_path
    }
  end
end
