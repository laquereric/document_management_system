require 'spec_helper'

# Require minimal Rails components
require 'action_controller/railtie'
require 'action_view/railtie'
require 'active_record/railtie'
require 'rails'

# Require gems used by the application
# require 'devise' # Removed - using custom authentication
require 'cancan'
require 'factory_bot'

# Create the Models module
module Models; end

# Load models
Dir[File.expand_path('../../app/models/*.rb', __FILE__)].each { |f| require f }

# Explicitly require the controllers we want to test
require_relative '../../app/controllers/application_controller'
require_relative '../../app/controllers/models/models_controller'
require_relative '../../app/controllers/models/documents_controller'

# Configure FactoryBot
FactoryBot.definition_file_paths = ['spec/factories']
FactoryBot.find_definitions

RSpec.describe Models::DocumentsController, type: :controller do
  include FactoryBot::Syntax::Methods
  
  let(:organization) { create(:organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:document) { create(:document, author: user, folder: folder) }

  before do
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
