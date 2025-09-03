require 'rails_helper'

RSpec.describe "Documents", type: :request do
  let(:user) { create(:user, :admin) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "returns http success" do
      get "/models/documents"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/models/documents/1"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/models/documents/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      post "/models/documents"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/models/documents/1/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      patch "/models/documents/1"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      delete "/models/documents/1"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /change_status" do
    it "returns http success" do
      patch "/models/documents/1/change_status"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /add_tag" do
    it "returns http success" do
      post "/models/documents/1/add_tag"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /remove_tag" do
    it "returns http success" do
      delete "/models/documents/1/remove_tag"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /search" do
    it "returns http success" do
      get "/models/documents/search"
      expect(response).to have_http_status(:success)
    end
  end
end
