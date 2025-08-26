require 'rails_helper'

RSpec.describe "Teams", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/teams/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/teams/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/teams/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/teams/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/teams/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/teams/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/teams/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /join" do
    it "returns http success" do
      get "/teams/join"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /leave" do
    it "returns http success" do
      get "/teams/leave"
      expect(response).to have_http_status(:success)
    end
  end

end
