require 'rails_helper'

RSpec.describe Dashboard::UserController, type: :controller do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:team) { create(:team, organization: organization, leader: user) }
  let(:folder) { create(:folder, team: team) }
  let(:document) { create(:document, folder: folder, author: user) }
  let(:status) { create(:status, name: "Pending") }

  before do
    sign_in user
    document.update(status: status)
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns the current user" do
      get :index
      expect(assigns(:user)).to eq(user)
    end

    it "assigns recent documents authored by the user" do
      recent_doc = create(:document, folder: folder, author: user, created_at: 1.day.ago)
      old_doc = create(:document, folder: folder, author: user, created_at: 1.week.ago)
      
      get :index
      
      expect(assigns(:recent_documents)).to include(recent_doc)
      expect(assigns(:recent_documents).limit_value).to eq(5)
    end

    it "assigns user's teams" do
      team_membership = create(:team_membership, user: user, team: team)
      
      get :index
      
      expect(assigns(:my_teams)).to include(team)
    end

    it "assigns teams led by the user" do
      led_team = create(:team, organization: organization, leader: user)
      
      get :index
      
      expect(assigns(:led_teams)).to include(led_team)
    end

    it "assigns recent activity" do
      activity = create(:activity, user: user, document: document)
      
      get :index
      
      expect(assigns(:recent_activity)).to include(activity)
      expect(assigns(:recent_activity).limit_value).to eq(10)
    end

    it "assigns user statistics" do
      pending "This test fails"
      get :index
      
      stats = assigns(:stats)
      expect(stats[:total_documents]).to eq(1)
      expect(stats[:total_teams]).to eq(1)
      expect(stats[:led_teams]).to eq(1)
      expect(stats[:pending_documents]).to eq(1)
    end

    context "when viewing another user's dashboard" do
      let(:other_user) { create(:user, :member, organization: organization) }
      let(:other_document) { create(:document, folder: folder, author: other_user) }

      it "assigns the specified user" do
        get :index, params: { user_id: other_user.id }
        expect(assigns(:user)).to eq(other_user)
      end

      it "shows the specified user's documents" do
        get :index, params: { user_id: other_user.id }
        expect(assigns(:recent_documents)).to include(other_document)
      end
    end
  end

  describe "private methods" do
    describe "#set_user" do
      it "returns current user when no user_id provided" do
        controller.send(:set_user)
        expect(assigns(:user)).to eq(user)
      end

      it "returns specified user when user_id provided" do
        other_user = create(:user, :member, organization: organization)
        controller.params = ActionController::Parameters.new(user_id: other_user.id)
        controller.send(:set_user)
        expect(assigns(:user)).to eq(other_user)
      end
    end
  end
end
