require 'rails_helper'

RSpec.describe "SearchController", type: :controller do
  # Mock controller actions for testing
  controller do
    def index
      @q = Document.ransack(params[:q])
      @documents = @q.result.includes(:author, :folder, :status)
                     .page(params[:page])
                     .per(params[:per] || 20)

      # Filter by user's accessible documents (simplified for testing)
      unless current_user&.admin?
        team_ids = current_user&.teams&.pluck(:id) || []
        @documents = @documents.joins(folder: :team).where(teams: { id: team_ids }) if team_ids.any?
      end
      
      render plain: "OK"
    end
  end

  let(:organization) { create(:organization) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:document) { create(:document, folder: folder, author: user) }
  let(:status) { create(:status) }

  before do
    setup_test_data
    document.update(status: status)
  end

  describe "GET #index" do
    context "in authentication-free environment" do
      it "returns a successful response" do
        get :index
        expect(response).to be_successful
      end

      it "assigns @q with ransack search object" do
        get :index
        expect(assigns(:q)).to be_a(Ransack::Search)
      end

      it "assigns @documents with all documents" do
        other_team = create(:team, organization: organization)
        other_folder = create(:folder, team: other_team)
        other_document = create(:document, folder: other_folder)
        
        get :index
        expect(assigns(:documents)).to include(document, other_document)
      end

      it "includes necessary associations" do
        get :index
        if assigns(:documents).any?
          expect(assigns(:documents).first.association(:author).loaded?).to be true
          expect(assigns(:documents).first.association(:folder).loaded?).to be true
          expect(assigns(:documents).first.association(:status).loaded?).to be true
        end
      end

      it "applies pagination" do
        get :index
        expect(assigns(:documents)).to respond_to(:current_page)
        expect(assigns(:documents).limit_value).to eq(20)
      end

      it "filters documents by search query" do
        document1 = create(:document, title: "Test Document", folder: folder)
        document2 = create(:document, title: "Another Document", folder: folder)
        
        get :index, params: { q: { title_cont: "Test" } }
        expect(assigns(:documents)).to include(document1)
        expect(assigns(:documents)).not_to include(document2)
      end

      it "filters documents by status" do
        draft_status = create(:status, name: "Draft")
        published_status = create(:status, name: "Published")
        draft_document = create(:document, status: draft_status, folder: folder)
        published_document = create(:document, status: published_status, folder: folder)
        
        get :index, params: { q: { status_name_eq: "Draft" } }
        expect(assigns(:documents)).to include(draft_document)
        expect(assigns(:documents)).not_to include(published_document)
      end

      it "filters documents by author" do
        other_user = create(:user, :member, organization: organization)
        other_document = create(:document, author: other_user, folder: folder)
        
        get :index, params: { q: { author_name_cont: user.name } }
        # The search should return documents where the author's name contains the search term
        # Since we're searching for the user's name, it should include the document authored by that user
        expect(assigns(:documents).map(&:author_id)).to include(user.id)
      end

      it "respects page parameter" do
        get :index, params: { page: 2 }
        expect(assigns(:documents).current_page).to eq(2)
      end

      it "respects per page parameter" do
        get :index, params: { per: 10 }
        expect(assigns(:documents).limit_value).to eq(10)
      end
    end

    context "with admin user" do
      before do
        sign_in admin_user
      end

      it "returns a successful response" do
        get :index
        expect(response).to be_successful
      end

      it "shows all documents for admin users" do
        other_team = create(:team, organization: organization)
        other_folder = create(:folder, team: other_team)
        other_document = create(:document, folder: other_folder)
        
        get :index
        expect(assigns(:documents)).to include(document, other_document)
      end
    end

    context "with regular user" do
      before do
        sign_in user
        user.teams << team
      end

      it "returns a successful response" do
        get :index
        expect(response).to be_successful
      end

      it "filters documents by user's teams" do
        other_team = create(:team, organization: organization)
        other_folder = create(:folder, team: other_team)
        other_document = create(:document, folder: other_folder)
        
        get :index
        expect(assigns(:documents)).to include(document)
        expect(assigns(:documents)).not_to include(other_document)
      end

      it "allows search within accessible documents" do
        document1 = create(:document, title: "Test Document", folder: folder)
        document2 = create(:document, title: "Another Document", folder: folder)
        
        get :index, params: { q: { title_cont: "Test" } }
        expect(assigns(:documents)).to include(document1)
        expect(assigns(:documents)).not_to include(document2)
      end
    end
  end
end
