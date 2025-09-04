require 'rails_helper'

RSpec.describe "Basic Request Test", type: :request do
  describe "GET /" do
    it "returns a successful response" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "displays the root page" do
      get root_path
      expect(response.body).to include("html")
    end
  end

  describe "GET /components" do
    it "returns a successful response" do
      get components_path
      expect(response).to have_http_status(:success)
    end

    it "displays the components page" do
      get components_path
      expect(response.body).to include("html")
    end
  end

  describe "GET /search" do
    it "returns a successful response" do
      get search_index_path
      expect(response).to have_http_status(:success)
    end

    it "displays the search page" do
      get search_index_path
      expect(response.body).to include("html")
    end
  end
end
