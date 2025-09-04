require 'rails_helper'

RSpec.describe Models::DocumentsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:document) { create(:document, author: user, folder: folder) }

  before do
    setup_test_data
    sign_in user
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @documents" do
      documents = create_list(:document, 3, author: user, folder: folder)
      get :index
      expect(assigns(:documents)).to include(*documents)
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: document.id }
      expect(response).to be_successful
    end

    it "assigns @document" do
      get :show, params: { id: document.id }
      expect(assigns(:document)).to eq(document)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns @document" do
      get :new
      expect(assigns(:document)).to be_a_new(Document)
    end
  end
end
