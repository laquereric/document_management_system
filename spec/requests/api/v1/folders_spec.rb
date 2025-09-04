require 'rails_helper'

RSpec.describe "API::V1::Folders", type: :request do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:document) { create(:document, folder: folder) }

  before do
    setup_test_data
  end

  describe "GET /api/v1/folders" do
    it "returns a successful response" do
      get api_v1_folders_path
      expect_successful_response
    end

    it "returns JSON format" do
      get api_v1_folders_path
      expect(response.content_type).to include("application/json")
    end

    it "returns folders data" do
      get api_v1_folders_path
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
    end

    it "includes folder attributes" do
      get api_v1_folders_path
      json_response = JSON.parse(response.body)
      if json_response.any?
        folder_data = json_response.first
        expect(folder_data).to have_key("id")
        expect(folder_data).to have_key("name")
        expect(folder_data).to have_key("description")
        expect(folder_data).to have_key("created_at")
        expect(folder_data).to have_key("updated_at")
      end
    end

    it "includes team information" do
      get api_v1_folders_path
      json_response = JSON.parse(response.body)
      if json_response.any?
        folder_data = json_response.first
        expect(folder_data).to have_key("team")
      end
    end

    it "includes documents count" do
      create_list(:document, 3, folder: folder)
      get api_v1_folders_path
      json_response = JSON.parse(response.body)
      if json_response.any?
        folder_data = json_response.first
        expect(folder_data).to have_key("documents_count")
      end
    end

    it "handles pagination parameters" do
      create_list(:folder, 25, team: team)
      get api_v1_folders_path, params: { page: 2, per_page: 10 }
      expect_successful_response
    end

    it "handles search parameters" do
      folder1 = create(:folder, name: "Important Folder", team: team)
      folder2 = create(:folder, name: "Regular Folder", team: team)
      
      get api_v1_folders_path, params: { q: { name_cont: "Important" } }
      expect_successful_response
    end

    it "handles sorting parameters" do
      get api_v1_folders_path, params: { sort: "name" }
      expect_successful_response
    end

    it "handles filtering parameters" do
      get api_v1_folders_path, params: { team_id: team.id }
      expect_successful_response
    end
  end

  describe "GET /api/v1/folders/:id" do
    it "returns a successful response" do
      get api_v1_folder_path(folder)
      expect_successful_response
    end

    it "returns JSON format" do
      get api_v1_folder_path(folder)
      expect(response.content_type).to include("application/json")
    end

    it "returns folder data" do
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_a(Hash)
    end

    it "includes folder attributes" do
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(folder.id)
      expect(json_response["name"]).to eq(folder.name)
      expect(json_response["description"]).to eq(folder.description)
    end

    it "includes team information" do
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      expect(json_response["team"]).to be_present
    end

    it "includes documents information" do
      create_list(:document, 3, folder: folder)
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      expect(json_response["documents"]).to be_an(Array)
    end

    it "includes documents count" do
      create_list(:document, 5, folder: folder)
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      expect(json_response["documents_count"]).to eq(5)
    end

    it "returns 404 for non-existent folder" do
      get api_v1_folder_path(999999)
      expect(response).to have_http_status(:not_found)
    end

    it "returns proper error message for non-existent folder" do
      get api_v1_folder_path(999999)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key("error")
    end
  end

  describe "API error handling" do
    it "handles malformed JSON requests" do
      get api_v1_folder_path(folder), 
          params: "invalid json", 
          headers: { 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(:bad_request)
    end

    it "handles missing parameters" do
      get api_v1_folders_path, params: {}
      expect_successful_response
    end

    it "handles invalid folder ID format" do
      get api_v1_folder_path("invalid")
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "API authentication" do
    it "allows access without authentication" do
      get api_v1_folders_path
      expect_successful_response
    end

    it "allows folder access without authentication" do
      get api_v1_folder_path(folder)
      expect_successful_response
    end
  end

  describe "API performance" do
    it "loads quickly with many folders" do
      create_list(:folder, 100, team: team)
      
      start_time = Time.current
      get api_v1_folders_path
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 2.seconds
    end

    it "handles folders with many documents efficiently" do
      create_list(:document, 50, folder: folder)
      
      start_time = Time.current
      get api_v1_folder_path(folder)
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 1.second
    end
  end

  describe "API data consistency" do
    it "returns consistent data structure" do
      get api_v1_folders_path
      json_response = JSON.parse(response.body)
      
      if json_response.any?
        folder_data = json_response.first
        expected_keys = ["id", "name", "description", "created_at", "updated_at", "team", "documents_count"]
        expect(folder_data.keys).to include(*expected_keys)
      end
    end

    it "returns consistent data types" do
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      
      expect(json_response["id"]).to be_a(Integer)
      expect(json_response["name"]).to be_a(String)
      expect(json_response["description"]).to be_a(String)
      expect(json_response["created_at"]).to be_a(String)
      expect(json_response["updated_at"]).to be_a(String)
    end
  end

  describe "API pagination" do
    before do
      create_list(:folder, 15, team: team)
    end

    it "returns paginated results" do
      get api_v1_folders_path, params: { page: 1, per_page: 10 }
      json_response = JSON.parse(response.body)
      expect(json_response.length).to be <= 10
    end

    it "handles page parameter" do
      get api_v1_folders_path, params: { page: 2 }
      expect_successful_response
    end

    it "handles per_page parameter" do
      get api_v1_folders_path, params: { per_page: 5 }
      json_response = JSON.parse(response.body)
      expect(json_response.length).to be <= 5
    end
  end

  describe "API search functionality" do
    it "filters folders by name" do
      folder1 = create(:folder, name: "Important Folder", team: team)
      folder2 = create(:folder, name: "Regular Folder", team: team)
      
      get api_v1_folders_path, params: { q: { name_cont: "Important" } }
      json_response = JSON.parse(response.body)
      expect(json_response.any? { |folder| folder["name"] == "Important Folder" }).to be true
    end

    it "filters folders by description" do
      folder1 = create(:folder, description: "This is about technology", team: team)
      folder2 = create(:folder, description: "This is about marketing", team: team)
      
      get api_v1_folders_path, params: { q: { description_cont: "technology" } }
      json_response = JSON.parse(response.body)
      expect(json_response.any? { |folder| folder["description"].include?("technology") }).to be true
    end

    it "filters folders by team" do
      team1 = create(:team, name: "Development Team", organization: organization)
      team2 = create(:team, name: "Marketing Team", organization: organization)
      folder1 = create(:folder, team: team1)
      folder2 = create(:folder, team: team2)
      
      get api_v1_folders_path, params: { q: { team_name_cont: "Development" } }
      json_response = JSON.parse(response.body)
      expect(json_response.any? { |folder| folder["team"]["name"] == "Development Team" }).to be true
    end
  end

  describe "API folder contents" do
    it "includes documents in folder response" do
      create_list(:document, 3, folder: folder)
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      expect(json_response["documents"]).to be_an(Array)
      expect(json_response["documents"].length).to eq(3)
    end

    it "includes document details in folder response" do
      doc = create(:document, folder: folder)
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      document_data = json_response["documents"].first
      expect(document_data).to have_key("id")
      expect(document_data).to have_key("title")
      expect(document_data).to have_key("content")
    end

    it "includes author information for documents" do
      doc = create(:document, folder: folder)
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      document_data = json_response["documents"].first
      expect(document_data["author"]).to be_present
    end

    it "includes status information for documents" do
      doc = create(:document, folder: folder)
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      document_data = json_response["documents"].first
      expect(document_data["status"]).to be_present
    end
  end

  describe "API team information" do
    it "includes team details in folder response" do
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      team_data = json_response["team"]
      expect(team_data).to have_key("id")
      expect(team_data).to have_key("name")
      expect(team_data).to have_key("description")
    end

    it "includes organization information in team data" do
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      team_data = json_response["team"]
      expect(team_data["organization"]).to be_present
    end

    it "includes team leader information" do
      get api_v1_folder_path(folder)
      json_response = JSON.parse(response.body)
      team_data = json_response["team"]
      expect(team_data["leader"]).to be_present
    end
  end
end
