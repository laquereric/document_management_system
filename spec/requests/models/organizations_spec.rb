require 'rails_helper'

RSpec.describe "Models::Organizations", type: :request do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }

  before do
    setup_test_data
  end

  describe "GET /models/organizations" do
    it "returns a successful response" do
      get models_organizations_path
      expect_successful_response
    end

    it "displays the organizations index page" do
      get models_organizations_path
      expect_page_to_contain("Organizations")
    end

    it "displays all organizations" do
      create_list(:organization, 5)
      get models_organizations_path
      expect_page_to_contain("Organizations")
    end

    it "includes organization information" do
      get models_organizations_path
      expect_page_to_contain(organization.name)
      expect_page_to_contain(organization.description)
    end

    it "includes user count for each organization" do
      create_list(:user, 3, organization: organization)
      get models_organizations_path
      expect_page_to_contain("Users")
    end

    it "includes team count for each organization" do
      create_list(:team, 2, organization: organization)
      get models_organizations_path
      expect_page_to_contain("Teams")
    end

    it "applies search filtering" do
      org1 = create(:organization, name: "Tech Corp")
      org2 = create(:organization, name: "Marketing Inc")
      
      get models_organizations_path, params: { q: { name_cont: "Tech" } }
      expect_page_to_contain("Tech Corp")
    end

    it "handles pagination" do
      create_list(:organization, 25)
      get models_organizations_path, params: { page: 2 }
      expect_successful_response
    end

    it "sorts organizations by name" do
      org1 = create(:organization, name: "Alpha Corp")
      org2 = create(:organization, name: "Beta Corp")
      
      get models_organizations_path, params: { sort: "name" }
      expect_successful_response
    end

    it "sorts organizations by created_at" do
      get models_organizations_path, params: { sort: "created_at" }
      expect_successful_response
    end
  end

  describe "GET /models/organizations/:id" do
    it "returns a successful response" do
      get models_organization_path(organization)
      expect_successful_response
    end

    it "displays organization information" do
      get models_organization_path(organization)
      expect_page_to_contain(organization.name)
      expect_page_to_contain(organization.description)
    end

    it "displays organization users" do
      create_list(:user, 3, organization: organization)
      get models_organization_path(organization)
      expect_page_to_contain("Users")
    end

    it "displays organization teams" do
      create_list(:team, 2, organization: organization)
      get models_organization_path(organization)
      expect_page_to_contain("Teams")
    end

    it "displays organization documents" do
      team = create(:team, organization: organization)
      folder = create(:folder, team: team)
      create_list(:document, 3, folder: folder)
      get models_organization_path(organization)
      expect_page_to_contain("Documents")
    end

    it "returns 404 for non-existent organization" do
      get models_organization_path(999999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /models/organizations/new" do
    it "returns a successful response" do
      get new_models_organization_path
      expect_successful_response
    end

    it "displays the new organization form" do
      get new_models_organization_path
      expect_page_to_contain("New Organization")
    end

    it "includes form fields" do
      get new_models_organization_path
      expect_page_to_contain("name")
      expect_page_to_contain("description")
    end
  end

  describe "POST /models/organizations" do
    let(:valid_attributes) do
      {
        name: "New Organization",
        description: "Organization description"
      }
    end

    it "creates a new organization" do
      expect {
        post models_organizations_path, params: { organization: valid_attributes }
      }.to change(Organization, :count).by(1)
    end

    it "redirects to the created organization" do
      post models_organizations_path, params: { organization: valid_attributes }
      expect_redirect_to(models_organization_path(Organization.last))
    end

    it "sets the correct attributes" do
      post models_organizations_path, params: { organization: valid_attributes }
      new_organization = Organization.last
      expect(new_organization.name).to eq("New Organization")
      expect(new_organization.description).to eq("Organization description")
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          name: "",
          description: ""
        }
      end

      it "does not create an organization" do
        expect {
          post models_organizations_path, params: { organization: invalid_attributes }
        }.not_to change(Organization, :count)
      end

      it "returns unprocessable entity status" do
        post models_organizations_path, params: { organization: invalid_attributes }
        expect_error_response
      end

      it "displays validation errors" do
        post models_organizations_path, params: { organization: invalid_attributes }
        expect_page_to_contain("error")
      end
    end

    context "with duplicate name" do
      before do
        create(:organization, name: "Existing Organization")
      end

      it "does not create an organization with duplicate name" do
        expect {
          post models_organizations_path, params: { organization: valid_attributes.merge(name: "Existing Organization") }
        }.not_to change(Organization, :count)
      end

      it "displays name uniqueness error" do
        post models_organizations_path, params: { organization: valid_attributes.merge(name: "Existing Organization") }
        expect_page_to_contain("has already been taken")
      end
    end
  end

  describe "GET /models/organizations/:id/edit" do
    it "returns a successful response" do
      get edit_models_organization_path(organization)
      expect_successful_response
    end

    it "displays the edit organization form" do
      get edit_models_organization_path(organization)
      expect_page_to_contain("Edit Organization")
    end

    it "pre-fills form with organization data" do
      get edit_models_organization_path(organization)
      expect_page_to_contain(organization.name)
      expect_page_to_contain(organization.description)
    end

    it "returns 404 for non-existent organization" do
      get edit_models_organization_path(999999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /models/organizations/:id" do
    let(:update_attributes) do
      {
        name: "Updated Organization Name",
        description: "Updated description"
      }
    end

    it "updates the organization" do
      patch models_organization_path(organization), params: { organization: update_attributes }
      organization.reload
      expect(organization.name).to eq("Updated Organization Name")
      expect(organization.description).to eq("Updated description")
    end

    it "redirects to the organization" do
      patch models_organization_path(organization), params: { organization: update_attributes }
      expect_redirect_to(models_organization_path(organization))
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          name: "",
          description: ""
        }
      end

      it "does not update the organization" do
        original_name = organization.name
        patch models_organization_path(organization), params: { organization: invalid_attributes }
        organization.reload
        expect(organization.name).to eq(original_name)
      end

      it "returns unprocessable entity status" do
        patch models_organization_path(organization), params: { organization: invalid_attributes }
        expect_error_response
      end
    end
  end

  describe "DELETE /models/organizations/:id" do
    it "deletes the organization" do
      organization_to_delete = create(:organization)
      expect {
        delete models_organization_path(organization_to_delete)
      }.to change(Organization, :count).by(-1)
    end

    it "redirects to organizations index" do
      delete models_organization_path(organization)
      expect_redirect_to(models_organizations_path)
    end

    it "handles deletion of organization with associations" do
      team = create(:team, organization: organization)
      folder = create(:folder, team: team)
      document = create(:document, folder: folder)
      
      expect {
        delete models_organization_path(organization)
      }.to change(Organization, :count).by(-1)
    end
  end

  describe "GET /models/organizations/user_organizations" do
    it "returns a successful response" do
      get user_organizations_models_organizations_path, params: { user_id: user.id }
      expect_successful_response
    end

    it "displays user's organizations" do
      team = create(:team, organization: organization)
      user.teams << team
      get user_organizations_models_organizations_path, params: { user_id: user.id }
      expect_page_to_contain(organization.name)
    end

    it "filters organizations by user's teams" do
      other_org = create(:organization)
      other_team = create(:team, organization: other_org)
      user.teams << other_team
      
      get user_organizations_models_organizations_path, params: { user_id: user.id }
      expect_page_to_contain(other_org.name)
    end

    it "handles pagination" do
      create_list(:team, 25, organization: organization) do |team|
        user.teams << team
      end
      
      get user_organizations_models_organizations_path, params: { user_id: user.id, page: 2 }
      expect_successful_response
    end
  end

  describe "authentication and authorization" do
    it "allows access without authentication" do
      get models_organizations_path
      expect_successful_response
    end

    it "allows creating organizations without authentication" do
      post models_organizations_path, params: { organization: { name: "Test Org", description: "Test" } }
      expect(response).to have_http_status(:redirect)
    end

    it "allows updating organizations without authentication" do
      patch models_organization_path(organization), params: { organization: { name: "Updated" } }
      expect(response).to have_http_status(:redirect)
    end

    it "allows deleting organizations without authentication" do
      delete models_organization_path(organization)
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "performance" do
    it "loads quickly with many organizations" do
      create_list(:organization, 100)
      
      start_time = Time.current
      get models_organizations_path
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 2.seconds
    end
  end

  describe "data integrity" do
    it "maintains referential integrity when deleting organizations" do
      team = create(:team, organization: organization)
      folder = create(:folder, team: team)
      document = create(:document, folder: folder)
      
      delete models_organization_path(organization)
      
      expect(Organization.exists?(organization.id)).to be false
      expect(Team.exists?(team.id)).to be false
      expect(Folder.exists?(folder.id)).to be false
      expect(Document.exists?(document.id)).to be false
    end
  end
end
