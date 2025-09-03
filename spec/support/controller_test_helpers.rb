module ControllerTestHelpers
  # Helper method to simulate having a current user (no authentication required)
  def sign_in(user = nil)
    @current_user = user || create_default_test_user
    allow(controller).to receive(:current_user).and_return(@current_user)
    allow(controller).to receive(:user_signed_in?).and_return(true)
  end

  # Helper method to simulate no current user
  def sign_out
    @current_user = nil
    allow(controller).to receive(:current_user).and_return(nil)
    allow(controller).to receive(:user_signed_in?).and_return(false)
  end

  # Helper method to create a default test user
  def create_default_test_user
    @default_organization ||= create(:organization, name: "Test Organization")
    @default_user ||= create(:user, :admin, organization: @default_organization)
  end

  # Helper method to get the current test user
  def current_user
    @current_user
  end

  # Helper method to create test data with proper associations
  def setup_test_data
    @organization = create(:organization)
    @admin_user = create(:user, :admin, organization: @organization)
    @team_leader = create(:user, :team_leader, organization: @organization)
    @member_user = create(:user, :member, organization: @organization)
    @team = create(:team, organization: @organization, leader: @team_leader)
    @folder = create(:folder, team: @team)
    @document = create(:document, folder: @folder, author: @member_user)
    @tag = create(:tag, organization: @organization)
  end
end
