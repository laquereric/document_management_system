class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_controller_path

  # Set current user for activity logging (no authentication required)
  before_action :set_current_user

  # Authorization
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  protected

  private

  def set_controller_path
    @controller_name = controller_name
    @action_name = action_name
  end

  def set_current_user
    # Always set a default admin user for the application
    admin_user = User.find_by(email: "admin@example.com")
    if admin_user
      Current.user = admin_user
      @current_user = admin_user
    else
      # Create admin user if it doesn't exist
      admin_user = create_default_admin_user
      Current.user = admin_user
      @current_user = admin_user
    end
  end

  def create_default_admin_user
    # Create organization first if it doesn't exist
    organization = Organization.find_or_create_by(name: "Default Organization") do |org|
      org.description = "Default organization for the application"
    end

    User.create!(
      email: "admin@example.com",
      name: "Admin User",
      role: "admin",
      organization: organization
    )
  rescue ActiveRecord::RecordInvalid => e
    # If user already exists, find and return it
    User.find_by(email: "admin@example.com")
  end

  # Always return the current user (no authentication required)
  def current_user
    @current_user
  end

  def user_signed_in?
    true # Always signed in
  end

  def ensure_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end

  def ensure_team_leader_or_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin? || current_user&.team_leader?
  end
end
