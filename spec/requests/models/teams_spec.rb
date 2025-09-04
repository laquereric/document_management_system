require 'rails_helper'

RSpec.describe "Models::Teams", type: :request do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }
  let(:team_leader) { create(:user, :team_leader, organization: organization) }
  let(:team) { create(:team, organization: organization, leader: team_leader) }

  before do
    setup_test_data
  end

  describe "GET /models/teams" do
    it "returns a successful response" do
      get models_teams_path
      expect_successful_response
    end

    it "displays the teams index page" do
      get models_teams_path
      expect_page_to_contain("Teams")
    end

    it "displays all teams" do
      create_list(:team, 5, organization: organization)
      get models_teams_path
      expect_page_to_contain("Teams")
    end

    it "includes team information" do
      get models_teams_path
      expect_page_to_contain(team.name)
      expect_page_to_contain(team.description)
    end

    it "includes organization information" do
      get models_teams_path
      expect_page_to_contain(organization.name)
    end

    it "includes team leader information" do
      get models_teams_path
      expect_page_to_contain(team_leader.name)
    end

    it "applies search filtering" do
      team1 = create(:team, name: "Development Team", organization: organization)
      team2 = create(:team, name: "Marketing Team", organization: organization)
      
      get models_teams_path, params: { q: { name_cont: "Development" } }
      expect_page_to_contain("Development Team")
    end

    it "applies organization filtering" do
      other_org = create(:organization)
      other_team = create(:team, organization: other_org)
      
      get models_teams_path, params: { q: { organization_id_eq: organization.id } }
      expect_page_to_contain(organization.name)
    end

    it "handles pagination" do
      create_list(:team, 25, organization: organization)
      get models_teams_path, params: { page: 2 }
      expect_successful_response
    end

    it "sorts teams by name" do
      team1 = create(:team, name: "Alpha Team", organization: organization)
      team2 = create(:team, name: "Beta Team", organization: organization)
      
      get models_teams_path, params: { sort: "name" }
      expect_successful_response
    end

    it "sorts teams by created_at" do
      get models_teams_path, params: { sort: "created_at" }
      expect_successful_response
    end
  end

  describe "GET /models/teams/:id" do
    it "returns a successful response" do
      get models_team_path(team)
      expect_successful_response
    end

    it "displays team information" do
      get models_team_path(team)
      expect_page_to_contain(team.name)
      expect_page_to_contain(team.description)
    end

    it "displays team's organization" do
      get models_team_path(team)
      expect_page_to_contain(organization.name)
    end

    it "displays team leader" do
      get models_team_path(team)
      expect_page_to_contain(team_leader.name)
    end

    it "displays team members" do
      member = create(:user, :member, organization: organization)
      team.users << member
      get models_team_path(team)
      expect_page_to_contain(member.name)
    end

    it "displays team folders" do
      folder = create(:folder, team: team)
      get models_team_path(team)
      expect_page_to_contain(folder.name)
    end

    it "displays team documents" do
      folder = create(:folder, team: team)
      document = create(:document, folder: folder)
      get models_team_path(team)
      expect_page_to_contain(document.title)
    end

    it "returns 404 for non-existent team" do
      get models_team_path(999999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /models/teams/new" do
    it "returns a successful response" do
      get new_models_team_path
      expect_successful_response
    end

    it "displays the new team form" do
      get new_models_team_path
      expect_page_to_contain("New Team")
    end

    it "includes form fields" do
      get new_models_team_path
      expect_page_to_contain("name")
      expect_page_to_contain("description")
      expect_page_to_contain("organization")
      expect_page_to_contain("leader")
    end

    it "includes organization options" do
      get new_models_team_path
      expect_page_to_contain(organization.name)
    end

    it "includes user options for team leader" do
      get new_models_team_path
      expect_page_to_contain(team_leader.name)
    end
  end

  describe "POST /models/teams" do
    let(:valid_attributes) do
      {
        name: "New Team",
        description: "Team description",
        organization_id: organization.id,
        leader_id: team_leader.id
      }
    end

    it "creates a new team" do
      expect {
        post models_teams_path, params: { team: valid_attributes }
      }.to change(Team, :count).by(1)
    end

    it "redirects to the created team" do
      post models_teams_path, params: { team: valid_attributes }
      expect_redirect_to(models_team_path(Team.last))
    end

    it "sets the correct attributes" do
      post models_teams_path, params: { team: valid_attributes }
      new_team = Team.last
      expect(new_team.name).to eq("New Team")
      expect(new_team.description).to eq("Team description")
      expect(new_team.organization).to eq(organization)
      expect(new_team.leader).to eq(team_leader)
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          name: "",
          description: "",
          organization_id: nil
        }
      end

      it "does not create a team" do
        expect {
          post models_teams_path, params: { team: invalid_attributes }
        }.not_to change(Team, :count)
      end

      it "returns unprocessable entity status" do
        post models_teams_path, params: { team: invalid_attributes }
        expect_error_response
      end

      it "displays validation errors" do
        post models_teams_path, params: { team: invalid_attributes }
        expect_page_to_contain("error")
      end
    end
  end

  describe "GET /models/teams/:id/edit" do
    it "returns a successful response" do
      get edit_models_team_path(team)
      expect_successful_response
    end

    it "displays the edit team form" do
      get edit_models_team_path(team)
      expect_page_to_contain("Edit Team")
    end

    it "pre-fills form with team data" do
      get edit_models_team_path(team)
      expect_page_to_contain(team.name)
      expect_page_to_contain(team.description)
    end

    it "returns 404 for non-existent team" do
      get edit_models_team_path(999999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /models/teams/:id" do
    let(:update_attributes) do
      {
        name: "Updated Team Name",
        description: "Updated description"
      }
    end

    it "updates the team" do
      patch models_team_path(team), params: { team: update_attributes }
      team.reload
      expect(team.name).to eq("Updated Team Name")
      expect(team.description).to eq("Updated description")
    end

    it "redirects to the team" do
      patch models_team_path(team), params: { team: update_attributes }
      expect_redirect_to(models_team_path(team))
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          name: "",
          description: ""
        }
      end

      it "does not update the team" do
        original_name = team.name
        patch models_team_path(team), params: { team: invalid_attributes }
        team.reload
        expect(team.name).to eq(original_name)
      end

      it "returns unprocessable entity status" do
        patch models_team_path(team), params: { team: invalid_attributes }
        expect_error_response
      end
    end
  end

  describe "DELETE /models/teams/:id" do
    it "deletes the team" do
      team_to_delete = create(:team, organization: organization)
      expect {
        delete models_team_path(team_to_delete)
      }.to change(Team, :count).by(-1)
    end

    it "redirects to teams index" do
      delete models_team_path(team)
      expect_redirect_to(models_teams_path)
    end

    it "handles deletion of team with associations" do
      folder = create(:folder, team: team)
      document = create(:document, folder: folder)
      
      expect {
        delete models_team_path(team)
      }.to change(Team, :count).by(-1)
    end
  end

  describe "POST /models/teams/:id/add_member" do
    let(:new_member) { create(:user, :member, organization: organization) }

    it "adds a member to the team" do
      expect {
        post add_member_models_team_path(team), params: { user_id: new_member.id }
      }.to change(team.users, :count).by(1)
    end

    it "redirects to the team" do
      post add_member_models_team_path(team), params: { user_id: new_member.id }
      expect_redirect_to(models_team_path(team))
    end

    it "does not add duplicate members" do
      team.users << new_member
      expect {
        post add_member_models_team_path(team), params: { user_id: new_member.id }
      }.not_to change(team.users, :count)
    end

    context "with redirect_to_user_profile parameter" do
      it "redirects to user profile" do
        post add_member_models_team_path(team), params: { 
          user_id: new_member.id, 
          redirect_to_user_profile: true 
        }
        expect_redirect_to(models_user_path(new_member))
      end
    end
  end

  describe "DELETE /models/teams/:id/remove_member" do
    let(:member) { create(:user, :member, organization: organization) }

    before do
      team.users << member
    end

    it "removes a member from the team" do
      expect {
        delete remove_member_models_team_path(team), params: { user_id: member.id }
      }.to change(team.users, :count).by(-1)
    end

    it "redirects to the team" do
      delete remove_member_models_team_path(team), params: { user_id: member.id }
      expect_redirect_to(models_team_path(team))
    end

    it "handles removal of non-member gracefully" do
      team.users.delete(member)
      expect {
        delete remove_member_models_team_path(team), params: { user_id: member.id }
      }.not_to change(team.users, :count)
    end
  end

  describe "POST /models/teams/:id/join" do
    let(:new_member) { create(:user, :member, organization: organization) }

    it "adds a member to the team" do
      expect {
        post join_models_team_path(team), params: { user_id: new_member.id }
      }.to change(team.members, :count).by(1)
    end

    it "redirects to the team" do
      post join_models_team_path(team), params: { user_id: new_member.id }
      expect_redirect_to(models_team_path(team))
    end

    it "does not add duplicate members" do
      team.members << new_member
      expect {
        post join_models_team_path(team), params: { user_id: new_member.id }
      }.not_to change(team.members, :count)
    end
  end

  describe "DELETE /models/teams/:id/leave" do
    let(:member) { create(:user, :member, organization: organization) }

    before do
      team.members << member
    end

    it "removes a member from the team" do
      expect {
        delete leave_models_team_path(team), params: { user_id: member.id }
      }.to change(team.members, :count).by(-1)
    end

    it "redirects to the team" do
      delete leave_models_team_path(team), params: { user_id: member.id }
      expect_redirect_to(models_team_path(team))
    end

    it "handles removal of non-member gracefully" do
      team.members.delete(member)
      expect {
        delete leave_models_team_path(team), params: { user_id: member.id }
      }.not_to change(team.members, :count)
    end
  end

  describe "authentication and authorization" do
    it "allows access without authentication" do
      get models_teams_path
      expect_successful_response
    end

    it "allows creating teams without authentication" do
      post models_teams_path, params: { team: { name: "Test Team", organization_id: organization.id, leader_id: team_leader.id } }
      expect(response).to have_http_status(:redirect)
    end

    it "allows updating teams without authentication" do
      patch models_team_path(team), params: { team: { name: "Updated" } }
      expect(response).to have_http_status(:redirect)
    end

    it "allows deleting teams without authentication" do
      delete models_team_path(team)
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "performance" do
    it "loads quickly with many teams" do
      create_list(:team, 100, organization: organization)
      
      start_time = Time.current
      get models_teams_path
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 2.seconds
    end
  end
end
