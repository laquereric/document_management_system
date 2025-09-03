require 'rails_helper'

RSpec.describe "Models::Documents", type: :request do
  let(:user) { create(:user, :admin) }
  let(:organization) { create(:organization) }
  let(:folder) { create(:folder, organization: organization) }
  let(:document) { create(:document, author: user, folder: folder) }
  let(:tag) { create(:tag) }

  # before do
  #   sign_in user
  # end

  describe "GET /models/documents" do
    it "returns a successful response" do
      get models_documents_path
      expect(response).to have_http_status(:success)
    end

    it "displays documents" do
      create_list(:document, 3, author: user, folder: folder)
      get models_documents_path
      expect(response.body).to include("Documents")
    end
  end

  describe "GET /models/documents/:id" do
    it "returns a successful response" do
      get models_document_path(document)
      expect(response).to have_http_status(:success)
    end

    it "displays the document" do
      get models_document_path(document)
      expect(response.body).to include(document.title)
    end

    it "returns 404 for non-existent document" do
      get models_document_path(999999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /models/documents/new" do
    it "returns a successful response" do
      get new_models_document_path
      expect(response).to have_http_status(:success)
    end

    it "displays the new document form" do
      get new_models_document_path
      expect(response.body).to include("New Document")
    end
  end

  describe "GET /models/documents/:id/edit" do
    it "returns a successful response" do
      get edit_models_document_path(document)
      expect(response).to have_http_status(:success)
    end

    it "displays the edit document form" do
      get edit_models_document_path(document)
      expect(response.body).to include("Edit Document")
    end

    it "returns 404 for non-existent document" do
      get edit_models_document_path(999999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /models/documents" do
    let(:valid_attributes) do
      {
        title: "Test Document",
        content: "Test content",
        folder_id: folder.id
      }
    end

    it "creates a new document" do
      expect {
        post models_documents_path, params: { document: valid_attributes }
      }.to change(Document, :count).by(1)
    end

    it "redirects to the created document" do
      post models_documents_path, params: { document: valid_attributes }
      expect(response).to redirect_to(models_document_path(Document.last))
    end

    it "sets the author to current user" do
      post models_documents_path, params: { document: valid_attributes }
      expect(Document.last.author).to eq(user)
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          title: "",
          content: "",
          folder_id: nil
        }
      end

      it "does not create a document" do
        expect {
          post models_documents_path, params: { document: invalid_attributes }
        }.not_to change(Document, :count)
      end

      it "returns unprocessable entity status" do
        post models_documents_path, params: { document: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /models/documents/:id" do
    let(:new_attributes) do
      {
        title: "Updated Document Title",
        content: "Updated content"
      }
    end

    it "updates the requested document" do
      patch models_document_path(document), params: { document: new_attributes }
      document.reload
      expect(document.title).to eq("Updated Document Title")
    end

    it "redirects to the document" do
      patch models_document_path(document), params: { document: new_attributes }
      expect(response).to redirect_to(models_document_path(document))
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          title: "",
          content: ""
        }
      end

      it "does not update the document" do
        original_title = document.title
        patch models_document_path(document), params: { document: invalid_attributes }
        document.reload
        expect(document.title).to eq(original_title)
      end

      it "returns unprocessable entity status" do
        patch models_document_path(document), params: { document: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /models/documents/:id" do
    it "destroys the requested document" do
      document_to_delete = create(:document, author: user, folder: folder)
      expect {
        delete models_document_path(document_to_delete)
      }.to change(Document, :count).by(-1)
    end

    it "redirects to the documents list" do
      delete models_document_path(document)
      expect(response).to redirect_to(models_documents_path)
    end
  end

  describe "PATCH /models/documents/:id/change_status" do
    let(:status) { create(:status) }

    it "changes the document status" do
      patch change_status_models_document_path(document), params: { status_id: status.id }
      document.reload
      expect(document.status).to eq(status)
    end

    it "redirects to the document" do
      patch change_status_models_document_path(document), params: { status_id: status.id }
      expect(response).to redirect_to(models_document_path(document))
    end
  end

  describe "POST /models/documents/:id/add_tag" do
    it "adds a tag to the document" do
      expect {
        post models_add_tag_path(document), params: { tag_id: tag.id }
      }.to change(document.tags, :count).by(1)
    end

    it "redirects to the document" do
      post models_add_tag_path(document), params: { tag_id: tag.id }
      expect(response).to redirect_to(models_document_path(document))
    end

    it "does not add duplicate tags" do
      document.tags << tag
      expect {
        post models_add_tag_path(document), params: { tag_id: tag.id }
      }.not_to change(document.tags, :count)
    end
  end

  describe "DELETE /models/documents/:id/remove_tag/:tag_id" do
    before do
      document.tags << tag
    end

    it "removes a tag from the document" do
      expect {
        delete models_remove_tag_path(document, tag)
      }.to change(document.tags, :count).by(-1)
    end

    it "redirects to the document" do
      delete models_remove_tag_path(document, tag)
      expect(response).to redirect_to(models_document_path(document))
    end
  end

  describe "GET /models/documents/search" do
    it "returns a successful response" do
      get models_documents_search_path
      expect(response).to have_http_status(:success)
    end

    it "displays search results" do
      get models_documents_search_path, params: { q: "test" }
      expect(response.body).to include("Search Results")
    end
  end

  describe "authentication" do
    context "when user is not signed in" do
      before { sign_out user }

      it "redirects to sign in page for index" do
        get models_documents_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects to sign in page for show" do
        get models_document_path(document)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects to sign in page for new" do
        get new_models_document_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects to sign in page for edit" do
        get edit_models_document_path(document)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects to sign in page for create" do
        post models_documents_path, params: { document: { title: "Test" } }
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects to sign in page for update" do
        patch models_document_path(document), params: { document: { title: "Updated" } }
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects to sign in page for destroy" do
        delete models_document_path(document)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "authorization" do
    let(:other_user) { create(:user) }
    let(:other_document) { create(:document, author: other_user, folder: folder) }

    context "when user is not admin and not the author" do
      before do
        user.update!(role: "member")
        sign_in user
      end

      it "allows viewing documents" do
        get models_document_path(other_document)
        expect(response).to have_http_status(:success)
      end

      it "denies editing other user's document" do
        get edit_models_document_path(other_document)
        expect(response).to have_http_status(:forbidden)
      end

      it "denies updating other user's document" do
        patch models_document_path(other_document), params: { document: { title: "Updated" } }
        expect(response).to have_http_status(:forbidden)
      end

      it "denies deleting other user's document" do
        delete models_document_path(other_document)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when user is admin" do
      before do
        user.update!(role: "admin")
        sign_in user
      end

      it "allows editing any document" do
        get edit_models_document_path(other_document)
        expect(response).to have_http_status(:success)
      end

      it "allows updating any document" do
        patch models_document_path(other_document), params: { document: { title: "Updated" } }
        expect(response).to redirect_to(models_document_path(other_document))
      end

      it "allows deleting any document" do
        expect {
          delete models_document_path(other_document)
        }.to change(Document, :count).by(-1)
      end
    end
  end
end
