require 'rails_helper'

RSpec.describe Dashboard::AdminController, type: :controller do
  let(:organization) { create(:organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }
  let(:member_user) { create(:user, :member, organization: organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:document) { create(:document, folder: folder) }
  let(:status) { create(:status, name: "Draft") }

  before do
    document.update(status: status)
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

      it "assigns system statistics" do
        get :index
        
        stats = assigns(:stats)
        expect(stats[:total_users]).to eq(2) # admin_user + member_user
        expect(stats[:total_organizations]).to eq(1)
        expect(stats[:total_teams]).to eq(1)
        expect(stats[:total_documents]).to eq(1)
        expect(stats[:total_folders]).to eq(1)
        expect(stats[:total_tags]).to eq(0)
      end

      it "assigns recent users" do
        get :index
        
        expect(assigns(:recent_users)).to include(admin_user, member_user)
        expect(assigns(:recent_users).limit_value).to eq(5)
      end

      it "assigns recent documents" do
        get :index
        
        expect(assigns(:recent_documents)).to include(document)
        expect(assigns(:recent_documents).limit_value).to eq(5)
      end

      it "assigns recent activity" do
        activity = create(:activity, user: admin_user, document: document)
        
        get :index
        
        expect(assigns(:recent_activity)).to include(activity)
        expect(assigns(:recent_activity).limit_value).to eq(10)
      end

      it "assigns users by role" do
        get :index
        
        users_by_role = assigns(:users_by_role)
        expect(users_by_role["admin"]).to eq(1)
        expect(users_by_role["member"]).to eq(1)
      end

      it "assigns documents by status" do
        get :index
        
        documents_by_status = assigns(:documents_by_status)
        expect(documents_by_status["Draft"]).to eq(1)
      end
    end

    context "when user is not admin" do
      before do
        sign_in member_user
      end

      it "redirects to root path with alert" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied. Admin privileges required.")
      end
    end
  end

  describe "private methods" do
    before do
      sign_in admin_user
    end

    describe "#require_admin!" do
      it "allows admin users" do
        expect { controller.send(:require_admin!) }.not_to raise_error
      end

      it "redirects non-admin users" do
        sign_in member_user
        expect(controller).to receive(:redirect_to).with(root_path, alert: "Access denied. Admin privileges required.")
        controller.send(:require_admin!)
      end
    end
  end
end
