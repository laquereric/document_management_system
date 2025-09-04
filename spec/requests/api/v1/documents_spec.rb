require 'rails_helper'

RSpec.describe "API::V1::Documents", type: :request do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:document) { create(:document, folder: folder, author: user) }
  let(:status) { create(:status, name: "Draft") }
  let(:tag) { create(:tag, organization: organization) }

  before do
    setup_test_data
    document.update(status: status)
    document.tags << tag
  end

  describe "GET /api/v1/documents" do
    it "returns a successful response" do
      get api_v1_documents_path
      expect_successful_response
    end

    it "returns JSON format" do
      get api_v1_documents_path
      expect(response.content_type).to include("application/json")
    end

    it "returns documents data" do
      get api_v1_documents_path
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
    end

    it "includes document attributes" do
      get api_v1_documents_path
      json_response = JSON.parse(response.body)
      if json_response.any?
        document_data = json_response.first
        expect(document_data).to have_key("id")
        expect(document_data).to have_key("title")
        expect(document_data).to have_key("content")
        expect(document_data).to have_key("created_at")
        expect(document_data).to have_key("updated_at")
      end
    end

    it "includes author information" do
      get api_v1_documents_path
      json_response = JSON.parse(response.body)
      if json_response.any?
        document_data = json_response.first
        expect(document_data).to have_key("author")
      end
    end

    it "includes folder information" do
      get api_v1_documents_path
      json_response = JSON.parse(response.body)
      if json_response.any?
        document_data = json_response.first
        expect(document_data).to have_key("folder")
      end
    end

    it "includes status information" do
      get api_v1_documents_path
      json_response = JSON.parse(response.body)
      if json_response.any?
        document_data = json_response.first
        expect(document_data).to have_key("status")
      end
    end

    it "includes tags information" do
      get api_v1_documents_path
      json_response = JSON.parse(response.body)
      if json_response.any?
        document_data = json_response.first
        expect(document_data).to have_key("tags")
      end
    end

    it "handles pagination parameters" do
      create_list(:document, 25, folder: folder)
      get api_v1_documents_path, params: { page: 2, per_page: 10 }
      expect_successful_response
    end

    it "handles search parameters" do
      doc1 = create(:document, title: "Important Document", folder: folder)
      doc2 = create(:document, title: "Regular Document", folder: folder)
      
      get api_v1_documents_path, params: { q: { title_cont: "Important" } }
      expect_successful_response
    end

    it "handles sorting parameters" do
      get api_v1_documents_path, params: { sort: "title" }
      expect_successful_response
    end

    it "handles filtering parameters" do
      get api_v1_documents_path, params: { status: "Draft" }
      expect_successful_response
    end
  end

  describe "GET /api/v1/documents/:id" do
    it "returns a successful response" do
      get api_v1_document_path(document)
      expect_successful_response
    end

    it "returns JSON format" do
      get api_v1_document_path(document)
      expect(response.content_type).to include("application/json")
    end

    it "returns document data" do
      get api_v1_document_path(document)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_a(Hash)
    end

    it "includes document attributes" do
      get api_v1_document_path(document)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(document.id)
      expect(json_response["title"]).to eq(document.title)
      expect(json_response["content"]).to eq(document.content)
    end

    it "includes author information" do
      get api_v1_document_path(document)
      json_response = JSON.parse(response.body)
      expect(json_response["author"]).to be_present
    end

    it "includes folder information" do
      get api_v1_document_path(document)
      json_response = JSON.parse(response.body)
      expect(json_response["folder"]).to be_present
    end

    it "includes status information" do
      get api_v1_document_path(document)
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to be_present
    end

    it "includes tags information" do
      get api_v1_document_path(document)
      json_response = JSON.parse(response.body)
      expect(json_response["tags"]).to be_an(Array)
    end

    it "returns 404 for non-existent document" do
      get api_v1_document_path(999999)
      expect(response).to have_http_status(:not_found)
    end

    it "returns proper error message for non-existent document" do
      get api_v1_document_path(999999)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key("error")
    end
  end

  describe "PATCH /api/v1/documents/:id" do
    let(:update_attributes) do
      {
        title: "Updated Document Title",
        content: "Updated content"
      }
    end

    it "returns a successful response" do
      patch api_v1_document_path(document), params: { document: update_attributes }
      expect_successful_response
    end

    it "returns JSON format" do
      patch api_v1_document_path(document), params: { document: update_attributes }
      expect(response.content_type).to include("application/json")
    end

    it "updates the document" do
      patch api_v1_document_path(document), params: { document: update_attributes }
      document.reload
      expect(document.title).to eq("Updated Document Title")
      expect(document.content).to eq("Updated content")
    end

    it "returns updated document data" do
      patch api_v1_document_path(document), params: { document: update_attributes }
      json_response = JSON.parse(response.body)
      expect(json_response["title"]).to eq("Updated Document Title")
      expect(json_response["content"]).to eq("Updated content")
    end

    it "handles status updates" do
      new_status = create(:status, name: "Published")
      patch api_v1_document_path(document), params: { document: { status_id: new_status.id } }
      document.reload
      expect(document.status).to eq(new_status)
    end

    it "handles tag updates" do
      new_tag = create(:tag, organization: organization)
      patch api_v1_document_path(document), params: { document: { tag_ids: [new_tag.id] } }
      document.reload
      expect(document.tags).to include(new_tag)
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          title: "",
          content: ""
        }
      end

      it "returns unprocessable entity status" do
        patch api_v1_document_path(document), params: { document: invalid_attributes }
        expect_error_response
      end

      it "returns validation errors" do
        patch api_v1_document_path(document), params: { document: invalid_attributes }
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end

      it "does not update the document" do
        original_title = document.title
        patch api_v1_document_path(document), params: { document: invalid_attributes }
        document.reload
        expect(document.title).to eq(original_title)
      end
    end

    it "returns 404 for non-existent document" do
      patch api_v1_document_path(999999), params: { document: update_attributes }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "API error handling" do
    it "handles malformed JSON requests" do
      patch api_v1_document_path(document), 
            params: "invalid json", 
            headers: { 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(:bad_request)
    end

    it "handles missing parameters" do
      patch api_v1_document_path(document), params: {}
      expect_successful_response
    end

    it "handles invalid document ID format" do
      get api_v1_document_path("invalid")
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "API authentication" do
    it "allows access without authentication" do
      get api_v1_documents_path
      expect_successful_response
    end

    it "allows document updates without authentication" do
      patch api_v1_document_path(document), params: { document: { title: "Updated" } }
      expect_successful_response
    end
  end

  describe "API performance" do
    it "loads quickly with many documents" do
      create_list(:document, 100, folder: folder)
      
      start_time = Time.current
      get api_v1_documents_path
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 2.seconds
    end

    it "handles large document content efficiently" do
      large_content = "a" * 10000
      document.update(content: large_content)
      
      start_time = Time.current
      get api_v1_document_path(document)
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 1.second
    end
  end

  describe "API data consistency" do
    it "returns consistent data structure" do
      get api_v1_documents_path
      json_response = JSON.parse(response.body)
      
      if json_response.any?
        document_data = json_response.first
        expected_keys = ["id", "title", "content", "created_at", "updated_at", "author", "folder", "status", "tags"]
        expect(document_data.keys).to include(*expected_keys)
      end
    end

    it "returns consistent data types" do
      get api_v1_document_path(document)
      json_response = JSON.parse(response.body)
      
      expect(json_response["id"]).to be_a(Integer)
      expect(json_response["title"]).to be_a(String)
      expect(json_response["content"]).to be_a(String)
      expect(json_response["created_at"]).to be_a(String)
      expect(json_response["updated_at"]).to be_a(String)
    end
  end

  describe "API pagination" do
    before do
      create_list(:document, 15, folder: folder)
    end

    it "returns paginated results" do
      get api_v1_documents_path, params: { page: 1, per_page: 10 }
      json_response = JSON.parse(response.body)
      expect(json_response.length).to be <= 10
    end

    it "handles page parameter" do
      get api_v1_documents_path, params: { page: 2 }
      expect_successful_response
    end

    it "handles per_page parameter" do
      get api_v1_documents_path, params: { per_page: 5 }
      json_response = JSON.parse(response.body)
      expect(json_response.length).to be <= 5
    end
  end

  describe "API search functionality" do
    it "filters documents by title" do
      doc1 = create(:document, title: "Important Document", folder: folder)
      doc2 = create(:document, title: "Regular Document", folder: folder)
      
      get api_v1_documents_path, params: { q: { title_cont: "Important" } }
      json_response = JSON.parse(response.body)
      expect(json_response.any? { |doc| doc["title"] == "Important Document" }).to be true
    end

    it "filters documents by content" do
      doc1 = create(:document, content: "This is about technology", folder: folder)
      doc2 = create(:document, content: "This is about marketing", folder: folder)
      
      get api_v1_documents_path, params: { q: { content_cont: "technology" } }
      json_response = JSON.parse(response.body)
      expect(json_response.any? { |doc| doc["content"].include?("technology") }).to be true
    end

    it "filters documents by author" do
      author1 = create(:user, name: "John Doe", organization: organization)
      author2 = create(:user, name: "Jane Smith", organization: organization)
      doc1 = create(:document, author: author1, folder: folder)
      doc2 = create(:document, author: author2, folder: folder)
      
      get api_v1_documents_path, params: { q: { author_name_cont: "John" } }
      json_response = JSON.parse(response.body)
      expect(json_response.any? { |doc| doc["author"]["name"] == "John Doe" }).to be true
    end
  end
end
