require 'rails_helper'

RSpec.describe "ApplicationController", type: :controller do
  # Mock controller actions for testing
  controller do
    def index
      render plain: "OK"
    end
  end

  describe "authentication and user management" do
    it "always has a current user" do
      get :index
      expect(controller.current_user).to be_present
      expect(controller.user_signed_in?).to be true
    end

    it "creates a default admin user if none exists" do
      User.destroy_all
      Organization.destroy_all
      
      get :index
      
      expect(User.count).to eq(1)
      expect(User.first.email).to eq("admin@example.com")
      expect(User.first.role).to eq("admin")
    end

    it "uses existing admin user if available" do
      organization = create(:organization, name: "Test Organization")
      existing_user = create(:user, email: "admin@example.com", role: "admin", organization: organization)
      
      get :index
      
      expect(controller.current_user).to eq(existing_user)
      expect(User.count).to eq(1)
    end
  end

  describe "authorization" do
    let(:organization) { create(:organization) }
    let(:admin_user) { create(:user, :admin, organization: organization) }
    let(:member_user) { create(:user, :member, organization: organization) }

    before do
      sign_in admin_user
    end

    it "allows admin users to access admin methods" do
      expect { controller.send(:ensure_admin) }.not_to raise_error
    end

    it "allows team leaders to access team leader methods" do
      team_leader = create(:user, :team_leader, organization: organization)
      sign_in team_leader
      
      expect { controller.send(:ensure_team_leader_or_admin) }.not_to raise_error
    end

    it "redirects non-admin users from admin methods" do
      sign_in member_user
      
      expect(controller).to receive(:redirect_to).with(controller.root_path, alert: "Access denied.")
      controller.send(:ensure_admin)
    end
  end

  describe "controller path setting" do
    it "sets controller and action names" do
      get :index
      
      expect(controller.instance_variable_get(:@controller_name)).to eq("application")
      expect(controller.instance_variable_get(:@action_name)).to eq("index")
    end
  end

  describe "CanCan authorization" do
    it "handles CanCan::AccessDenied exceptions" do
      allow(controller).to receive(:root_path).and_return("/")
      
      expect(controller).to receive(:redirect_to).with("/", alert: "Access denied.")
      controller.send(:rescue_from, CanCan::AccessDenied.new("Access denied."))
    end
  end
end
