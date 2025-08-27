class Forms::OrganizationFormComponent < ApplicationComponent
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

  def name_field_classes
    "form-control input-lg"
  end

  def description_field_classes
    "form-control"
  end

  def submit_button_classes
    "btn btn-primary"
  end

  def cancel_button_classes
    "btn"
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
end
