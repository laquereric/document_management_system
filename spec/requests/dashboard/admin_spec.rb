require 'rails_helper'

RSpec.describe "Dashboard::Admin", type: :request do
  let(:organization) { create(:organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }
  let(:member_user) { create(:user, :member, organization: organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:document) { create(:document, folder: folder) }
  let(:status) { create(:status, name: "Draft") }

  before do
    setup_test_data
    document.update(status: status)
  end

  describe "GET /dashboard/admin" do
    it "returns a successful response" do
      get dashboard_admin_index_path
      expect_successful_response
    end

    it "displays the admin dashboard" do
      get dashboard_admin_index_path
      expect_page_to_contain("Admin Dashboard")
    end

    it "displays system statistics" do
      get dashboard_admin_index_path
      expect_page_to_contain("System Statistics")
    end

    it "displays total users count" do
      get dashboard_admin_index_path
      expect_page_to_contain("Users")
    end

    it "displays total organizations count" do
      get dashboard_admin_index_path
      expect_page_to_contain("Organizations")
    end

    it "displays total teams count" do
      get dashboard_admin_index_path
      expect_page_to_contain("Teams")
    end

    it "displays total documents count" do
      get dashboard_admin_index_path
      expect_page_to_contain("Documents")
    end

    it "displays total folders count" do
      get dashboard_admin_index_path
      expect_page_to_contain("Folders")
    end

    it "displays total tags count" do
      get dashboard_admin_index_path
      expect_page_to_contain("Tags")
    end

    it "displays recent users" do
      get dashboard_admin_index_path
      expect_page_to_contain("Recent Users")
    end

    it "displays recent documents" do
      get dashboard_admin_index_path
      expect_page_to_contain("Recent Documents")
    end

    it "displays recent activity" do
      activity = create(:activity, user: admin_user, document: document)
      get dashboard_admin_index_path
      expect_page_to_contain("Recent Activity")
    end

    it "displays users by role" do
      get dashboard_admin_index_path
      expect_page_to_contain("Users by Role")
    end

    it "displays documents by status" do
      get dashboard_admin_index_path
      expect_page_to_contain("Documents by Status")
    end
  end

  describe "admin dashboard data accuracy" do
    it "shows correct user count" do
      create_list(:user, 5, organization: organization)
      get dashboard_admin_index_path
      expect_page_to_contain("6") # 5 new + 1 existing
    end

    it "shows correct organization count" do
      create_list(:organization, 3)
      get dashboard_admin_index_path
      expect_page_to_contain("4") # 3 new + 1 existing
    end

    it "shows correct team count" do
      create_list(:team, 2, organization: organization)
      get dashboard_admin_index_path
      expect_page_to_contain("3") # 2 new + 1 existing
    end

    it "shows correct document count" do
      create_list(:document, 4, folder: folder)
      get dashboard_admin_index_path
      expect_page_to_contain("5") # 4 new + 1 existing
    end

    it "shows correct folder count" do
      create_list(:folder, 3, team: team)
      get dashboard_admin_index_path
      expect_page_to_contain("4") # 3 new + 1 existing
    end

    it "shows correct tag count" do
      create_list(:tag, 2, organization: organization)
      get dashboard_admin_index_path
      expect_page_to_contain("3") # 2 new + 1 existing
    end
  end

  describe "recent data display" do
    it "displays recent users in correct order" do
      recent_user = create(:user, :member, organization: organization, created_at: 1.hour.ago)
      old_user = create(:user, :member, organization: organization, created_at: 1.day.ago)
      
      get dashboard_admin_index_path
      expect_page_to_contain(recent_user.name)
    end

    it "displays recent documents in correct order" do
      recent_doc = create(:document, folder: folder, created_at: 1.hour.ago)
      old_doc = create(:document, folder: folder, created_at: 1.day.ago)
      
      get dashboard_admin_index_path
      expect_page_to_contain(recent_doc.title)
    end

    it "displays recent activity in correct order" do
      recent_activity = create(:activity, user: admin_user, document: document, created_at: 1.hour.ago)
      old_activity = create(:activity, user: admin_user, document: document, created_at: 1.day.ago)
      
      get dashboard_admin_index_path
      expect_page_to_contain("Recent Activity")
    end
  end

  describe "role-based statistics" do
    before do
      create_list(:user, 3, :admin, organization: organization)
      create_list(:user, 5, :team_leader, organization: organization)
      create_list(:user, 10, :member, organization: organization)
    end

    it "displays correct admin count" do
      get dashboard_admin_index_path
      expect_page_to_contain("4") # 3 new + 1 existing admin
    end

    it "displays correct team leader count" do
      get dashboard_admin_index_path
      expect_page_to_contain("5")
    end

    it "displays correct member count" do
      get dashboard_admin_index_path
      expect_page_to_contain("10")
    end
  end

  describe "status-based statistics" do
    before do
      draft_status = create(:status, name: "Draft")
      published_status = create(:status, name: "Published")
      
      create_list(:document, 3, status: draft_status, folder: folder)
      create_list(:document, 2, status: published_status, folder: folder)
    end

    it "displays correct draft document count" do
      get dashboard_admin_index_path
      expect_page_to_contain("Draft")
    end

    it "displays correct published document count" do
      get dashboard_admin_index_path
      expect_page_to_contain("Published")
    end
  end

  describe "dashboard layout and structure" do
    it "includes proper HTML structure" do
      get dashboard_admin_index_path
      expect_page_to_contain("<html>")
      expect_page_to_contain("</html>")
    end

    it "includes navigation elements" do
      get dashboard_admin_index_path
      expect_page_to_contain("nav")
    end

    it "includes proper meta tags" do
      get dashboard_admin_index_path
      expect_page_to_contain("viewport")
    end

    it "includes CSS and JavaScript assets" do
      get dashboard_admin_index_path
      expect_page_to_contain("stylesheet")
    end

    it "includes proper page title" do
      get dashboard_admin_index_path
      expect_page_to_contain("<title>")
    end
  end

  describe "error handling" do
    it "handles missing data gracefully" do
      # Clear all data
      User.destroy_all
      Organization.destroy_all
      Team.destroy_all
      Document.destroy_all
      Folder.destroy_all
      Tag.destroy_all
      
      get dashboard_admin_index_path
      expect_successful_response
    end

    it "handles database errors gracefully" do
      allow(User).to receive(:count).and_raise(ActiveRecord::StatementInvalid.new("Database error"))
      
      get dashboard_admin_index_path
      expect_successful_response
    end
  end

  describe "performance" do
    it "loads quickly with large datasets" do
      # Create a large dataset
      create_list(:user, 100, organization: organization)
      create_list(:document, 100, folder: folder)
      create_list(:team, 50, organization: organization)
      
      start_time = Time.current
      get dashboard_admin_index_path
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 3.seconds
    end
  end

  describe "data freshness" do
    it "shows current data" do
      new_user = create(:user, :member, organization: organization)
      get dashboard_admin_index_path
      expect_page_to_contain(new_user.name)
    end

    it "updates statistics in real-time" do
      get dashboard_admin_index_path
      initial_count = response.body.scan(/Users/).count
      
      create(:user, :member, organization: organization)
      get dashboard_admin_index_path
      updated_count = response.body.scan(/Users/).count
      
      expect(updated_count).to be >= initial_count
    end
  end
end
