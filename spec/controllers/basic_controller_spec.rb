require 'rails_helper'

RSpec.describe "Basic Controller Test", type: :controller do
  controller do
    def index
      render plain: "OK"
    end
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end
  end
end
