require 'rails_helper'

RSpec.describe "ActivityLogs", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/activity_logs/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/activity_logs/show"
      expect(response).to have_http_status(:success)
    end
  end
end
