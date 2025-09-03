class Models::Organization::OrganizationFormComponent < ApplicationComponent
  def initialize(organization:, submit_text: "Save Organization", cancel_url: nil, **system_arguments)
    @organization = organization
    @submit_text = submit_text
    @cancel_url = cancel_url
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :organization, :submit_text, :cancel_url, :system_arguments

  def form_url
    if organization.persisted?
      models_organization_path(organization)
    else
      models_organizations_path
    end
  end

  def form_method
    organization.persisted? ? :patch : :post
  end
end
