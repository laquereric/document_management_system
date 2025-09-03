require 'rails_helper'

RSpec.describe Models::OrganizationsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }
  let(:team) { create(:team, organization: organization) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @q with ransack search object" do
      get :index
      expect(assigns(:q)).to be_a(Ransack::Search)
    end

    it "assigns @organizations with all organizations" do
      organizations = create_list(:organization, 3)
      get :index
      expect(assigns(:organizations)).to include(*organizations)
    end

    it "includes necessary associations" do
      get :index
      expect(assigns(:organizations).first.association(:users).loaded?).to be true
      expect(assigns(:organizations).first.association(:teams).loaded?).to be true
    end

    it "applies pagination" do
      get :index
      expect(assigns(:organizations)).to respond_to(:current_page)
      expect(assigns(:organizations).limit_value).to eq(20)
    end

    it "orders organizations by created_at desc" do
      org1 = create(:organization, created_at: 1.day.ago)
      org2 = create(:organization, created_at: 2.days.ago)
      
      get :index
      expect(assigns(:organizations).first).to eq(org1)
      expect(assigns(:organizations).last).to eq(org2)
    end

    it "filters organizations by search query" do
      org1 = create(:organization, name: "Test Organization")
      org2 = create(:organization, name: "Another Organization")
      
      get :index, params: { q: { name_cont: "Test" } }
      expect(assigns(:organizations)).to include(org1)
      expect(assigns(:organizations)).not_to include(org2)
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: organization.id }
      expect(response).to be_successful
    end

    it "assigns @organization" do
      get :show, params: { id: organization.id }
      expect(assigns(:organization)).to eq(organization)
    end
  end

  describe "GET #new" do
    context "when user is admin" do
      before do
        sign_in admin_user
      end

      it "returns a successful response" do
        get :new
        expect(response).to be_successful
      end

      it "assigns @organization" do
        get :new
        expect(assigns(:organization)).to be_a_new(Organization)
      end
    end

    context "when user is not admin" do
      it "redirects with access denied message" do
        get :new
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied. Admin privileges required.")
      end
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        name: "New Organization",
        description: "Organization description"
      }
    end

    context "when user is admin" do
      before do
        sign_in admin_user
      end

      it "creates a new organization" do
        expect {
          post :create, params: { organization: valid_params }
        }.to change(Organization, :count).by(1)
      end

      it "redirects to the organization on success" do
        post :create, params: { organization: valid_params }
        expect(response).to redirect_to(models_organization_path(Organization.last))
        expect(flash[:notice]).to eq("Organization was successfully created.")
      end

      context "with invalid parameters" do
        let(:invalid_params) { { name: "" } }

        it "does not create an organization" do
          expect {
            post :create, params: { organization: invalid_params }
          }.not_to change(Organization, :count)
        end

        it "renders new template" do
          post :create, params: { organization: invalid_params }
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when user is not admin" do
      it "redirects with access denied message" do
        post :create, params: { organization: valid_params }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied. Admin privileges required.")
      end
    end
  end

  describe "GET #edit" do
    context "when user is admin" do
      before do
        sign_in admin_user
      end

      it "returns a successful response" do
        get :edit, params: { id: organization.id }
        expect(response).to be_successful
      end

      it "assigns @organization" do
        get :edit, params: { id: organization.id }
        expect(assigns(:organization)).to eq(organization)
      end
    end

    context "when user is not admin" do
      it "redirects with access denied message" do
        get :edit, params: { id: organization.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied. Admin privileges required.")
      end
    end
  end

  describe "PATCH #update" do
    let(:update_params) { { name: "Updated Organization Name" } }

    context "when user is admin" do
      before do
        sign_in admin_user
      end

      it "updates the organization" do
        patch :update, params: { id: organization.id, organization: update_params }
        organization.reload
        expect(organization.name).to eq("Updated Organization Name")
      end

      it "redirects to the organization on success" do
        patch :update, params: { id: organization.id, organization: update_params }
        expect(response).to redirect_to(models_organization_path(organization))
        expect(flash[:notice]).to eq("Organization was successfully updated.")
      end

      context "with invalid parameters" do
        let(:invalid_params) { { name: "" } }

        it "does not update the organization" do
          original_name = organization.name
          patch :update, params: { id: organization.id, organization: invalid_params }
          organization.reload
          expect(organization.name).to eq(original_name)
        end

        it "renders edit template" do
          patch :update, params: { id: organization.id, organization: invalid_params }
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when user is not admin" do
      it "redirects with access denied message" do
        patch :update, params: { id: organization.id, organization: update_params }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied. Admin privileges required.")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is admin" do
      before do
        sign_in admin_user
      end

      it "deletes the organization" do
        expect {
          delete :destroy, params: { id: organization.id }
        }.to change(Organization, :count).by(-1)
      end

      it "redirects to organizations index" do
        delete :destroy, params: { id: organization.id }
        expect(response).to redirect_to(models_organizations_path)
        expect(flash[:notice]).to eq("Organization was successfully deleted.")
      end
    end

    context "when user is not admin" do
      it "redirects with access denied message" do
        delete :destroy, params: { id: organization.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied. Admin privileges required.")
      end
    end
  end

  describe "GET #user_organizations" do
    it "returns a successful response" do
      get :user_organizations, params: { user_id: user.id }
      expect(response).to be_successful
    end

    it "assigns @user" do
      get :user_organizations, params: { user_id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it "assigns @organizations with user's organizations" do
      user.teams << team
      get :user_organizations, params: { user_id: user.id }
      expect(assigns(:organizations)).to include(organization)
    end

    it "renders user_organizations template" do
      get :user_organizations, params: { user_id: user.id }
      expect(response).to render_template(:user_organizations)
    end
  end
end
