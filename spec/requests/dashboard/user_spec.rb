require 'rails_helper'

RSpec.describe "Dashboard::User", type: :request do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:team) { create(:team, organization: organization, leader: user) }
  let(:folder) { create(:folder, team: team) }
  let(:document) { create(:document, folder: folder, author: user) }
  let(:status) { create(:status, name: "Pending") }

  before do
    setup_test_data
    document.update(status: status)
  end

  describe "GET /dashboard/user" do
    it "returns a successful response" do
      get dashboard_user_index_path
      expect_successful_response
    end

    it "displays the user dashboard" do
      get dashboard_user_index_path
      expect_page_to_contain("Dashboard")
    end

    it "displays user information" do
      get dashboard_user_index_path
      expect_page_to_contain(user.name)
    end

    it "displays recent documents" do
      recent_doc = create(:document, folder: folder, author: user, created_at: 1.day.ago)
      get dashboard_user_index_path
      expect_page_to_contain(recent_doc.title)
    end

    it "displays user's teams" do
      team_membership = create(:team_membership, user: user, team: team)
      get dashboard_user_index_path
      expect_page_to_contain(team.name)
    end

    it "displays teams led by the user" do
      led_team = create(:team, organization: organization, leader: user)
      get dashboard_user_index_path
      expect_page_to_contain(led_team.name)
    end

    it "displays recent activity" do
      activity = create(:activity, user: user, document: document)
      get dashboard_user_index_path
      expect_page_to_contain("Recent Activity")
    end

    it "displays user statistics" do
      get dashboard_user_index_path
      expect_page_to_contain("Statistics")
    end

    context "when viewing another user's dashboard" do
      let(:other_user) { create(:user, :member, organization: organization) }
      let(:other_document) { create(:document, folder: folder, author: other_user) }

      it "displays the specified user's information" do
        get dashboard_user_index_path, params: { user_id: other_user.id }
        expect_page_to_contain(other_user.name)
      end

      it "displays the specified user's documents" do
        get dashboard_user_index_path, params: { user_id: other_user.id }
        expect_page_to_contain(other_document.title)
      end
    end

    context "with pagination" do
      before do
        # Create multiple documents to test pagination
        create_list(:document, 15, folder: folder, author: user)
      end

      it "displays paginated results" do
        get dashboard_user_index_path
        expect_successful_response
      end

      it "handles page parameter" do
        get dashboard_user_index_path, params: { page: 2 }
        expect_successful_response
      end
    end

    context "with search parameters" do
      it "filters results when search is provided" do
        get dashboard_user_index_path, params: { q: "test" }
        expect_successful_response
      end
    end
  end

  describe "GET /dashboard/user with different user roles" do
    context "when user is admin" do
      let(:admin_user) { create(:user, :admin, organization: organization) }

      it "displays admin-specific information" do
        get dashboard_user_index_path, params: { user_id: admin_user.id }
        expect_successful_response
      end
    end

    context "when user is team leader" do
      let(:team_leader) { create(:user, :team_leader, organization: organization) }
      let(:led_team) { create(:team, organization: organization, leader: team_leader) }

      it "displays team leader information" do
        get dashboard_user_index_path, params: { user_id: team_leader.id }
        expect_page_to_contain(led_team.name)
      end
    end

    context "when user is member" do
      it "displays member information" do
        get dashboard_user_index_path, params: { user_id: user.id }
        expect_successful_response
      end
    end
  end

  describe "dashboard content validation" do
    it "includes proper HTML structure" do
      get dashboard_user_index_path
      expect_page_to_contain("<html>")
      expect_page_to_contain("</html>")
    end

    it "includes navigation elements" do
      get dashboard_user_index_path
      expect_page_to_contain("nav")
    end

    it "includes proper meta tags" do
      get dashboard_user_index_path
      expect_page_to_contain("viewport")
    end

    it "includes CSS and JavaScript assets" do
      get dashboard_user_index_path
      expect_page_to_contain("stylesheet")
    end
  end

  describe "error handling" do
    it "handles invalid user_id gracefully" do
      get dashboard_user_index_path, params: { user_id: 999999 }
      expect_successful_response
    end

    it "handles missing parameters gracefully" do
      get dashboard_user_index_path, params: {}
      expect_successful_response
    end
  end

  describe "performance" do
    it "loads quickly with large datasets" do
      # Create a large dataset
      create_list(:document, 100, folder: folder, author: user)
      create_list(:team, 10, organization: organization)
      
      start_time = Time.current
      get dashboard_user_index_path
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 2.seconds
    end
  end
end
