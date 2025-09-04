require 'rails_helper'

RSpec.describe "Models::Users", type: :request do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }
  let(:team_leader) { create(:user, :team_leader, organization: organization) }

  before do
    setup_test_data
  end

  describe "GET /models/users" do
    it "returns a successful response" do
      get models_users_path
      expect_successful_response
    end

    it "displays the users index page" do
      get models_users_path
      expect_page_to_contain("Users")
    end

    it "displays all users" do
      create_list(:user, 5, organization: organization)
      get models_users_path
      expect_page_to_contain("Users")
    end

    it "includes user information" do
      get models_users_path
      expect_page_to_contain(user.name)
      expect_page_to_contain(user.email)
    end

    it "includes organization information" do
      get models_users_path
      expect_page_to_contain(organization.name)
    end

    it "includes team information" do
      team = create(:team, organization: organization)
      user.teams << team
      get models_users_path
      expect_page_to_contain(team.name)
    end

    it "applies search filtering" do
      user1 = create(:user, name: "John Doe", organization: organization)
      user2 = create(:user, name: "Jane Smith", organization: organization)
      
      get models_users_path, params: { q: { name_cont: "John" } }
      expect_page_to_contain("John Doe")
    end

    it "applies role filtering" do
      get models_users_path, params: { q: { role_eq: "admin" } }
      expect_page_to_contain("admin")
    end

    it "applies organization filtering" do
      other_org = create(:organization)
      other_user = create(:user, organization: other_org)
      
      get models_users_path, params: { q: { organization_id_eq: organization.id } }
      expect_page_to_contain(organization.name)
    end

    it "handles pagination" do
      create_list(:user, 25, organization: organization)
      get models_users_path, params: { page: 2 }
      expect_successful_response
    end

    it "sorts users by name" do
      user1 = create(:user, name: "Alice", organization: organization)
      user2 = create(:user, name: "Bob", organization: organization)
      
      get models_users_path, params: { sort: "name" }
      expect_successful_response
    end

    it "sorts users by email" do
      get models_users_path, params: { sort: "email" }
      expect_successful_response
    end

    it "sorts users by role" do
      get models_users_path, params: { sort: "role" }
      expect_successful_response
    end

    it "sorts users by created_at" do
      get models_users_path, params: { sort: "created_at" }
      expect_successful_response
    end
  end

  describe "GET /models/users/:id" do
    it "returns a successful response" do
      get models_user_path(user)
      expect_successful_response
    end

    it "displays user information" do
      get models_user_path(user)
      expect_page_to_contain(user.name)
      expect_page_to_contain(user.email)
      expect_page_to_contain(user.role)
    end

    it "displays user's organization" do
      get models_user_path(user)
      expect_page_to_contain(organization.name)
    end

    it "displays user's teams" do
      team = create(:team, organization: organization)
      user.teams << team
      get models_user_path(user)
      expect_page_to_contain(team.name)
    end

    it "displays user's authored documents" do
      folder = create(:folder, team: create(:team, organization: organization))
      document = create(:document, author: user, folder: folder)
      get models_user_path(user)
      expect_page_to_contain(document.title)
    end

    it "displays user's activities" do
      folder = create(:folder, team: create(:team, organization: organization))
      document = create(:document, author: user, folder: folder)
      activity = create(:activity, user: user, document: document)
      get models_user_path(user)
      expect_page_to_contain("Activities")
    end

    it "returns 404 for non-existent user" do
      get models_user_path(999999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /models/users/new" do
    it "returns a successful response" do
      get new_models_user_path
      expect_successful_response
    end

    it "displays the new user form" do
      get new_models_user_path
      expect_page_to_contain("New User")
    end

    it "includes form fields" do
      get new_models_user_path
      expect_page_to_contain("name")
      expect_page_to_contain("email")
      expect_page_to_contain("role")
      expect_page_to_contain("organization")
    end

    it "includes organization options" do
      get new_models_user_path
      expect_page_to_contain(organization.name)
    end
  end

  describe "POST /models/users" do
    let(:valid_attributes) do
      {
        name: "New User",
        email: "newuser@example.com",
        role: "member",
        organization_id: organization.id
      }
    end

    it "creates a new user" do
      expect {
        post models_users_path, params: { user: valid_attributes }
      }.to change(User, :count).by(1)
    end

    it "redirects to the created user" do
      post models_users_path, params: { user: valid_attributes }
      expect_redirect_to(models_user_path(User.last))
    end

    it "sets the correct attributes" do
      post models_users_path, params: { user: valid_attributes }
      new_user = User.last
      expect(new_user.name).to eq("New User")
      expect(new_user.email).to eq("newuser@example.com")
      expect(new_user.role).to eq("member")
      expect(new_user.organization).to eq(organization)
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          name: "",
          email: "invalid-email",
          role: "invalid_role"
        }
      end

      it "does not create a user" do
        expect {
          post models_users_path, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it "returns unprocessable entity status" do
        post models_users_path, params: { user: invalid_attributes }
        expect_error_response
      end

      it "displays validation errors" do
        post models_users_path, params: { user: invalid_attributes }
        expect_page_to_contain("error")
      end
    end

    context "with duplicate email" do
      before do
        create(:user, email: "existing@example.com", organization: organization)
      end

      it "does not create a user with duplicate email" do
        expect {
          post models_users_path, params: { user: valid_attributes.merge(email: "existing@example.com") }
        }.not_to change(User, :count)
      end

      it "displays email uniqueness error" do
        post models_users_path, params: { user: valid_attributes.merge(email: "existing@example.com") }
        expect_page_to_contain("has already been taken")
      end
    end
  end

  describe "GET /models/users/:id/edit" do
    it "returns a successful response" do
      get edit_models_user_path(user)
      expect_successful_response
    end

    it "displays the edit user form" do
      get edit_models_user_path(user)
      expect_page_to_contain("Edit User")
    end

    it "pre-fills form with user data" do
      get edit_models_user_path(user)
      expect_page_to_contain(user.name)
      expect_page_to_contain(user.email)
    end

    it "returns 404 for non-existent user" do
      get edit_models_user_path(999999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /models/users/:id" do
    let(:update_attributes) do
      {
        name: "Updated Name",
        email: "updated@example.com",
        role: "team_leader"
      }
    end

    it "updates the user" do
      patch models_user_path(user), params: { user: update_attributes }
      user.reload
      expect(user.name).to eq("Updated Name")
      expect(user.email).to eq("updated@example.com")
      expect(user.role).to eq("team_leader")
    end

    it "redirects to the user" do
      patch models_user_path(user), params: { user: update_attributes }
      expect_redirect_to(models_user_path(user))
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          name: "",
          email: "invalid-email"
        }
      end

      it "does not update the user" do
        original_name = user.name
        patch models_user_path(user), params: { user: invalid_attributes }
        user.reload
        expect(user.name).to eq(original_name)
      end

      it "returns unprocessable entity status" do
        patch models_user_path(user), params: { user: invalid_attributes }
        expect_error_response
      end
    end
  end

  describe "DELETE /models/users/:id" do
    it "deletes the user" do
      user_to_delete = create(:user, organization: organization)
      expect {
        delete models_user_path(user_to_delete)
      }.to change(User, :count).by(-1)
    end

    it "redirects to users index" do
      delete models_user_path(user)
      expect_redirect_to(models_users_path)
    end

    it "handles deletion of user with associations" do
      team = create(:team, organization: organization, leader: user)
      folder = create(:folder, team: team)
      document = create(:document, author: user, folder: folder)
      
      expect {
        delete models_user_path(user)
      }.to change(User, :count).by(-1)
    end
  end

  describe "PATCH /models/users/:id/toggle_role" do
    it "toggles user role from member to admin" do
      patch toggle_role_models_user_path(user)
      user.reload
      expect(user.role).to eq("admin")
    end

    it "toggles user role from admin to member" do
      patch toggle_role_models_user_path(admin_user)
      admin_user.reload
      expect(admin_user.role).to eq("member")
    end

    it "redirects to the user" do
      patch toggle_role_models_user_path(user)
      expect_redirect_to(models_user_path(user))
    end

    it "handles toggle failure gracefully" do
      allow_any_instance_of(User).to receive(:update).and_return(false)
      patch toggle_role_models_user_path(user)
      expect_redirect_to(models_user_path(user))
    end
  end

  describe "authentication and authorization" do
    it "allows access without authentication" do
      get models_users_path
      expect_successful_response
    end

    it "allows creating users without authentication" do
      post models_users_path, params: { user: { name: "Test", email: "test@example.com", role: "member", organization_id: organization.id } }
      expect(response).to have_http_status(:redirect)
    end

    it "allows updating users without authentication" do
      patch models_user_path(user), params: { user: { name: "Updated" } }
      expect(response).to have_http_status(:redirect)
    end

    it "allows deleting users without authentication" do
      delete models_user_path(user)
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "performance" do
    it "loads quickly with many users" do
      create_list(:user, 100, organization: organization)
      
      start_time = Time.current
      get models_users_path
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 2.seconds
    end
  end
end
