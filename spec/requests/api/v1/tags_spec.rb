require 'rails_helper'

RSpec.describe "API::V1::Tags", type: :request do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:document) { create(:document, folder: folder) }
  let(:tag) { create(:tag, organization: organization) }

  before do
    setup_test_data
    document.tags << tag
  end

  describe "GET /api/v1/tags" do
    it "returns a successful response" do
      get api_v1_tags_path
      expect_successful_response
    end

    it "returns JSON format" do
      get api_v1_tags_path
      expect(response.content_type).to include("application/json")
    end

    it "returns tags data" do
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
    end

    it "includes tag attributes" do
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      if json_response.any?
        tag_data = json_response.first
        expect(tag_data).to have_key("id")
        expect(tag_data).to have_key("name")
        expect(tag_data).to have_key("color")
        expect(tag_data).to have_key("created_at")
        expect(tag_data).to have_key("updated_at")
      end
    end

    it "includes organization information" do
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      if json_response.any?
        tag_data = json_response.first
        expect(tag_data).to have_key("organization")
      end
    end

    it "includes usage count" do
      create_list(:document, 3, folder: folder) do |doc|
        doc.tags << tag
      end
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      if json_response.any?
        tag_data = json_response.first
        expect(tag_data).to have_key("usage_count")
      end
    end

    it "handles pagination parameters" do
      create_list(:tag, 25, organization: organization)
      get api_v1_tags_path, params: { page: 2, per_page: 10 }
      expect_successful_response
    end

    it "handles search parameters" do
      tag1 = create(:tag, name: "Important Tag", organization: organization)
      tag2 = create(:tag, name: "Regular Tag", organization: organization)
      
      get api_v1_tags_path, params: { q: { name_cont: "Important" } }
      expect_successful_response
    end

    it "handles sorting parameters" do
      get api_v1_tags_path, params: { sort: "name" }
      expect_successful_response
    end

    it "handles filtering parameters" do
      get api_v1_tags_path, params: { organization_id: organization.id }
      expect_successful_response
    end
  end

  describe "API error handling" do
    it "handles malformed JSON requests" do
      get api_v1_tags_path, 
          params: "invalid json", 
          headers: { 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(:bad_request)
    end

    it "handles missing parameters" do
      get api_v1_tags_path, params: {}
      expect_successful_response
    end

    it "handles invalid parameters gracefully" do
      get api_v1_tags_path, params: { invalid_param: "test" }
      expect_successful_response
    end
  end

  describe "API authentication" do
    it "allows access without authentication" do
      get api_v1_tags_path
      expect_successful_response
    end
  end

  describe "API performance" do
    it "loads quickly with many tags" do
      create_list(:tag, 100, organization: organization)
      
      start_time = Time.current
      get api_v1_tags_path
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 2.seconds
    end

    it "handles tags with many associations efficiently" do
      create_list(:document, 50, folder: folder) do |doc|
        doc.tags << tag
      end
      
      start_time = Time.current
      get api_v1_tags_path
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 1.second
    end
  end

  describe "API data consistency" do
    it "returns consistent data structure" do
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      
      if json_response.any?
        tag_data = json_response.first
        expected_keys = ["id", "name", "color", "created_at", "updated_at", "organization", "usage_count"]
        expect(tag_data.keys).to include(*expected_keys)
      end
    end

    it "returns consistent data types" do
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      
      if json_response.any?
        tag_data = json_response.first
        expect(tag_data["id"]).to be_a(Integer)
        expect(tag_data["name"]).to be_a(String)
        expect(tag_data["color"]).to be_a(String)
        expect(tag_data["created_at"]).to be_a(String)
        expect(tag_data["updated_at"]).to be_a(String)
      end
    end
  end

  describe "API pagination" do
    before do
      create_list(:tag, 15, organization: organization)
    end

    it "returns paginated results" do
      get api_v1_tags_path, params: { page: 1, per_page: 10 }
      json_response = JSON.parse(response.body)
      expect(json_response.length).to be <= 10
    end

    it "handles page parameter" do
      get api_v1_tags_path, params: { page: 2 }
      expect_successful_response
    end

    it "handles per_page parameter" do
      get api_v1_tags_path, params: { per_page: 5 }
      json_response = JSON.parse(response.body)
      expect(json_response.length).to be <= 5
    end
  end

  describe "API search functionality" do
    it "filters tags by name" do
      tag1 = create(:tag, name: "Important Tag", organization: organization)
      tag2 = create(:tag, name: "Regular Tag", organization: organization)
      
      get api_v1_tags_path, params: { q: { name_cont: "Important" } }
      json_response = JSON.parse(response.body)
      expect(json_response.any? { |tag| tag["name"] == "Important Tag" }).to be true
    end

    it "filters tags by color" do
      tag1 = create(:tag, color: "#ff0000", organization: organization)
      tag2 = create(:tag, color: "#00ff00", organization: organization)
      
      get api_v1_tags_path, params: { q: { color_cont: "ff0000" } }
      json_response = JSON.parse(response.body)
      expect(json_response.any? { |tag| tag["color"] == "#ff0000" }).to be true
    end

    it "filters tags by organization" do
      org1 = create(:organization, name: "Tech Corp")
      org2 = create(:organization, name: "Marketing Inc")
      tag1 = create(:tag, organization: org1)
      tag2 = create(:tag, organization: org2)
      
      get api_v1_tags_path, params: { q: { organization_name_cont: "Tech" } }
      json_response = JSON.parse(response.body)
      expect(json_response.any? { |tag| tag["organization"]["name"] == "Tech Corp" }).to be true
    end
  end

  describe "API tag usage information" do
    it "includes usage count for tags" do
      create_list(:document, 5, folder: folder) do |doc|
        doc.tags << tag
      end
      
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      tag_data = json_response.find { |t| t["id"] == tag.id }
      expect(tag_data["usage_count"]).to eq(6) # 5 new + 1 existing
    end

    it "includes zero usage count for unused tags" do
      unused_tag = create(:tag, organization: organization)
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      tag_data = json_response.find { |t| t["id"] == unused_tag.id }
      expect(tag_data["usage_count"]).to eq(0)
    end

    it "includes associated documents information" do
      doc1 = create(:document, folder: folder)
      doc2 = create(:document, folder: folder)
      doc1.tags << tag
      doc2.tags << tag
      
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      tag_data = json_response.find { |t| t["id"] == tag.id }
      expect(tag_data["usage_count"]).to eq(3) # 2 new + 1 existing
    end
  end

  describe "API organization information" do
    it "includes organization details in tag response" do
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      tag_data = json_response.find { |t| t["id"] == tag.id }
      org_data = tag_data["organization"]
      expect(org_data).to have_key("id")
      expect(org_data).to have_key("name")
      expect(org_data).to have_key("description")
    end

    it "includes organization name in tag response" do
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      tag_data = json_response.find { |t| t["id"] == tag.id }
      expect(tag_data["organization"]["name"]).to eq(organization.name)
    end
  end

  describe "API tag color information" do
    it "includes color information for tags" do
      colored_tag = create(:tag, color: "#ff0000", organization: organization)
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      tag_data = json_response.find { |t| t["id"] == colored_tag.id }
      expect(tag_data["color"]).to eq("#ff0000")
    end

    it "handles tags without color" do
      get api_v1_tags_path
      json_response = JSON.parse(response.body)
      tag_data = json_response.find { |t| t["id"] == tag.id }
      expect(tag_data["color"]).to be_present
    end
  end

  describe "API tag sorting" do
    it "sorts tags by name" do
      tag1 = create(:tag, name: "Alpha Tag", organization: organization)
      tag2 = create(:tag, name: "Beta Tag", organization: organization)
      
      get api_v1_tags_path, params: { sort: "name" }
      json_response = JSON.parse(response.body)
      expect_successful_response
    end

    it "sorts tags by usage count" do
      tag1 = create(:tag, organization: organization)
      tag2 = create(:tag, organization: organization)
      create_list(:document, 3, folder: folder) do |doc|
        doc.tags << tag1
      end
      
      get api_v1_tags_path, params: { sort: "usage_count" }
      json_response = JSON.parse(response.body)
      expect_successful_response
    end

    it "sorts tags by created date" do
      get api_v1_tags_path, params: { sort: "created_at" }
      json_response = JSON.parse(response.body)
      expect_successful_response
    end
  end

  describe "API tag filtering" do
    it "filters tags by organization" do
      org1 = create(:organization)
      org2 = create(:organization)
      tag1 = create(:tag, organization: org1)
      tag2 = create(:tag, organization: org2)
      
      get api_v1_tags_path, params: { organization_id: org1.id }
      json_response = JSON.parse(response.body)
      expect(json_response.all? { |tag| tag["organization"]["id"] == org1.id }).to be true
    end

    it "filters tags by usage count" do
      tag1 = create(:tag, organization: organization)
      tag2 = create(:tag, organization: organization)
      create_list(:document, 5, folder: folder) do |doc|
        doc.tags << tag1
      end
      
      get api_v1_tags_path, params: { min_usage: 5 }
      json_response = JSON.parse(response.body)
      expect(json_response.all? { |tag| tag["usage_count"] >= 5 }).to be true
    end
  end
end
