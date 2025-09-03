require 'rails_helper'

RSpec.describe Models::DocumentsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }
  let(:document) { create(:document, author: user, folder: folder) }
  let(:status) { create(:status) }
  let(:scenario) { create(:scenario) }
  let(:tag) { create(:tag) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when user is admin" do
      before do
        sign_in admin_user
      end

      it "returns a successful response" do
        get :index
        expect(response).to be_successful
      end

      it "assigns @documents with all documents" do
        documents = create_list(:document, 3, author: user, folder: folder)
        get :index
        expect(assigns(:documents)).to include(*documents)
      end

      it "applies search when query parameter is present" do
        document1 = create(:document, title: "Test Document", author: user, folder: folder)
        document2 = create(:document, title: "Another Document", author: user, folder: folder)
        
        get :index, params: { q: { title_cont: "Test" } }
        expect(assigns(:documents)).to include(document1)
        expect(assigns(:documents)).not_to include(document2)
      end

      it "applies sorting by title" do
        document1 = create(:document, title: "A Document", author: user, folder: folder)
        document2 = create(:document, title: "Z Document", author: user, folder: folder)
        
        get :index, params: { sort: "title" }
        expect(assigns(:documents).first).to eq(document1)
        expect(assigns(:documents).last).to eq(document2)
      end

      it "applies sorting by status" do
        status1 = create(:status, name: "A Status")
        status2 = create(:status, name: "Z Status")
        document1 = create(:document, status: status1, author: user, folder: folder)
        document2 = create(:document, status: status2, author: user, folder: folder)
        
        get :index, params: { sort: "status" }
        expect(assigns(:documents).first).to eq(document1)
        expect(assigns(:documents).last).to eq(document2)
      end
    end

    context "when user is not admin" do
      it "returns only documents from user's teams" do
        other_team = create(:team, organization: organization)
        other_folder = create(:folder, team: other_team)
        other_document = create(:document, author: user, folder: other_folder)
        
        get :index
        expect(assigns(:documents)).to include(document)
        expect(assigns(:documents)).not_to include(other_document)
      end
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

    it "assigns @activities" do
      activity = create(:activity, document: document, user: user)
      get :show, params: { id: document.id }
      expect(assigns(:activities)).to include(activity)
    end

    context "when user cannot access document" do
      let(:other_team) { create(:team, organization: organization) }
      let(:other_document) { create(:document, author: user, folder: create(:folder, team: other_team)) }

      it "redirects with access denied message" do
        get :show, params: { id: other_document.id }
        expect(response).to redirect_to(models_documents_path)
        expect(flash[:alert]).to eq("You do not have permission to access this document.")
      end
    end
  end

  describe "GET #new" do
    context "with folder_id parameter" do
      it "returns a successful response" do
        get :new, params: { folder_id: folder.id }
        expect(response).to be_successful
      end

      it "assigns @document with folder association" do
        get :new, params: { folder_id: folder.id }
        expect(assigns(:document).folder).to eq(folder)
      end
    end

    context "without folder_id parameter" do
      it "returns a successful response" do
        get :new
        expect(response).to be_successful
      end

      it "assigns @document without folder" do
        get :new
        expect(assigns(:document).folder).to be_nil
      end
    end

    it "assigns @statuses" do
      get :new
      expect(assigns(:statuses)).to eq(Status.all)
    end

    it "assigns @scenarios" do
      get :new
      expect(assigns(:scenarios)).to eq(Scenario.all)
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        title: "New Document",
        content: "Document content",
        status_id: status.id,
        scenario_id: scenario.id
      }
    end

    context "with folder_id parameter" do
      it "creates a new document" do
        expect {
          post :create, params: { folder_id: folder.id, document: valid_params }
        }.to change(Document, :count).by(1)
      end

      it "associates document with folder" do
        post :create, params: { folder_id: folder.id, document: valid_params }
        expect(Document.last.folder).to eq(folder)
      end
    end

    context "without folder_id parameter" do
      it "creates a new document" do
        expect {
          post :create, params: { document: valid_params }
        }.to change(Document, :count).by(1)
      end
    end

    it "sets the author to current user" do
      post :create, params: { document: valid_params }
      expect(Document.last.author).to eq(user)
    end

    it "creates an activity record" do
      expect {
        post :create, params: { document: valid_params }
      }.to change(Activity, :count).by(1)
    end

    it "redirects to the document on success" do
      post :create, params: { document: valid_params }
      expect(response).to redirect_to(Document.last)
      expect(flash[:notice]).to eq("Document was successfully created.")
    end

    context "with invalid parameters" do
      let(:invalid_params) { { title: "" } }

      it "does not create a document" do
        expect {
          post :create, params: { document: invalid_params }
        }.not_to change(Document, :count)
      end

      it "renders new template" do
        post :create, params: { document: invalid_params }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: document.id }
      expect(response).to be_successful
    end

    it "assigns @document" do
      get :edit, params: { id: document.id }
      expect(assigns(:document)).to eq(document)
    end

    it "assigns @statuses" do
      get :edit, params: { id: document.id }
      expect(assigns(:statuses)).to eq(Status.all)
    end

    it "assigns @scenarios" do
      get :edit, params: { id: document.id }
      expect(assigns(:scenarios)).to eq(Scenario.all)
    end
  end

  describe "PATCH #update" do
    let(:update_params) { { title: "Updated Title" } }

    it "updates the document" do
      patch :update, params: { id: document.id, document: update_params }
      document.reload
      expect(document.title).to eq("Updated Title")
    end

    it "creates an activity record" do
      expect {
        patch :update, params: { id: document.id, document: update_params }
      }.to change(Activity, :count).by(1)
    end

    it "redirects to the document on success" do
      patch :update, params: { id: document.id, document: update_params }
      expect(response).to redirect_to(document)
      expect(flash[:notice]).to eq("Document was successfully updated.")
    end

    context "with invalid parameters" do
      let(:invalid_params) { { title: "" } }

      it "does not update the document" do
        original_title = document.title
        patch :update, params: { id: document.id, document: invalid_params }
        document.reload
        expect(document.title).to eq(original_title)
      end

      it "renders edit template" do
        patch :update, params: { id: document.id, document: invalid_params }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the document" do
      expect {
        delete :destroy, params: { id: document.id }
      }.to change(Document, :count).by(-1)
    end

    it "creates an activity record" do
      expect {
        delete :destroy, params: { id: document.id }
      }.to change(Activity, :count).by(1)
    end

    it "redirects to documents index" do
      delete :destroy, params: { id: document.id }
      expect(response).to redirect_to(models_documents_path)
      expect(flash[:notice]).to eq("Document was successfully deleted.")
    end
  end

  describe "PATCH #change_status" do
    let(:new_status) { create(:status, name: "New Status") }

    it "updates the document status" do
      patch :change_status, params: { id: document.id, status_id: new_status.id }
      document.reload
      expect(document.status).to eq(new_status)
    end

    it "creates an activity record" do
      expect {
        patch :change_status, params: { id: document.id, status_id: new_status.id }
      }.to change(Activity, :count).by(1)
    end

    it "redirects to the document" do
      patch :change_status, params: { id: document.id, status_id: new_status.id }
      expect(response).to redirect_to(document)
      expect(flash[:notice]).to eq("Status updated successfully.")
    end
  end

  describe "POST #add_tag" do
    it "adds the tag to the document" do
      expect {
        post :add_tag, params: { id: document.id, tag_id: tag.id }
      }.to change(document.tags, :count).by(1)
    end

    it "creates an activity record" do
      expect {
        post :add_tag, params: { id: document.id, tag_id: tag.id }
      }.to change(Activity, :count).by(1)
    end

    it "redirects to the document" do
      post :add_tag, params: { id: document.id, tag_id: tag.id }
      expect(response).to redirect_to(document)
    end

    it "does not add duplicate tags" do
      document.tags << tag
      expect {
        post :add_tag, params: { id: document.id, tag_id: tag.id }
      }.not_to change(document.tags, :count)
    end
  end

  describe "DELETE #remove_tag" do
    before do
      document.tags << tag
    end

    it "removes the tag from the document" do
      expect {
        delete :remove_tag, params: { id: document.id, tag_id: tag.id }
      }.to change(document.tags, :count).by(-1)
    end

    it "creates an activity record" do
      expect {
        delete :remove_tag, params: { id: document.id, tag_id: tag.id }
      }.to change(Activity, :count).by(1)
    end

    it "redirects to the document" do
      delete :remove_tag, params: { id: document.id, tag_id: tag.id }
      expect(response).to redirect_to(document)
    end
  end

  describe "GET #search" do
    it "returns a successful response" do
      get :search
      expect(response).to be_successful
    end

    it "assigns @documents with search results" do
      document1 = create(:document, title: "Test Document", author: user, folder: folder)
      document2 = create(:document, title: "Another Document", author: user, folder: folder)
      
      get :search, params: { q: { title_cont: "Test" } }
      expect(assigns(:documents)).to include(document1)
      expect(assigns(:documents)).not_to include(document2)
    end

    context "when user is not admin" do
      it "filters results by user's teams" do
        other_team = create(:team, organization: organization)
        other_folder = create(:folder, team: other_team)
        other_document = create(:document, author: user, folder: other_folder)
        
        get :search
        expect(assigns(:documents)).to include(document)
        expect(assigns(:documents)).not_to include(other_document)
      end
    end
  end
end
