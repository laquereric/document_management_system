module RequestTestHelpers
  # Helper method to simulate having a current user (no authentication required)
  def sign_in(user = nil)
    @current_user = user || create_default_test_user
    # In request tests, we don't need to mock controller methods
    # The application will automatically set the current user
  end

  # Helper method to simulate no current user
  def sign_out
    @current_user = nil
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
    @status = create(:status)
    @scenario = create(:scenario)
  end

  # Helper method to create a complete document with all associations
  def create_complete_document(attributes = {})
    organization = create(:organization)
    team = create(:team, organization: organization)
    folder = create(:folder, team: team)
    author = create(:user, :member, organization: organization)
    status = create(:status)
    scenario = create(:scenario)
    
    create(:document, {
      folder: folder,
      author: author,
      status: status,
      scenario: scenario
    }.merge(attributes))
  end

  # Helper method to create a complete team with members
  def create_complete_team(attributes = {})
    organization = create(:organization)
    leader = create(:user, :team_leader, organization: organization)
    team = create(:team, {
      organization: organization,
      leader: leader
    }.merge(attributes))
    
    # Add some members
    3.times do
      member = create(:user, :member, organization: organization)
      team.users << member
    end
    
    team
  end

  # Helper method to create a complete organization with teams and users
  def create_complete_organization(attributes = {})
    organization = create(:organization, attributes)
    
    # Create admin user
    admin = create(:user, :admin, organization: organization)
    
    # Create teams with leaders and members
    2.times do
      team_leader = create(:user, :team_leader, organization: organization)
      team = create(:team, organization: organization, leader: team_leader)
      
      # Add members to team
      3.times do
        member = create(:user, :member, organization: organization)
        team.users << member
      end
    end
    
    organization
  end

  # Helper method to test JSON responses
  def json_response
    JSON.parse(response.body)
  end

  # Helper method to test HTML content
  def expect_page_to_contain(text)
    expect(response.body).to include(text)
  end

  # Helper method to test page title
  def expect_page_title(title)
    expect(response.body).to include("<title>#{title}</title>")
  end

  # Helper method to test flash messages
  def expect_flash_message(type, message)
    expect(flash[type]).to eq(message)
  end

  # Helper method to test redirects
  def expect_redirect_to(path)
    expect(response).to redirect_to(path)
  end

  # Helper method to test successful response
  def expect_successful_response
    expect(response).to have_http_status(:success)
  end

  # Helper method to test error response
  def expect_error_response(status = :unprocessable_entity)
    expect(response).to have_http_status(status)
  end
end
