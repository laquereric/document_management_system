class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  before_action :set_controller_path

  # Devise authentication - skip if CI/CD security is disabled
  before_action :authenticate_user!, unless: :cicd_security_disabled?
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # Set current user for activity logging
  before_action :set_current_user
  
  # Authorization
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :organization_id, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :organization_id, :role])
  end
  
  private
  
  def set_controller_path
    @controller_name = controller_name
    @action_name = action_name
  end

  def set_current_user
    if cicd_security_disabled?
      # Set admin user for CI/CD environments
      cicd_user = User.find_by(email: 'admin@example.com')
      if cicd_user
        Current.user = cicd_user
        # Set current_user for Devise compatibility
        @current_user = cicd_user
      else
        # Create admin user if it doesn't exist
        cicd_user = create_cicd_admin_user
        Current.user = cicd_user
        @current_user = cicd_user
      end
    else
      Current.user = current_user if user_signed_in?
    end
  end

  def create_cicd_admin_user
    User.create!(
      email: 'admin@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      name: 'CI/CD Admin',
      role: 'admin',
      confirmed_at: Time.current
    )
  rescue ActiveRecord::RecordInvalid => e
    # If user already exists, find and return it
    User.find_by(email: 'admin@example.com')
  end
  
  def cicd_security_disabled?
    defined?(CiCdSecurityDisable) && CiCdSecurityDisable == true
  end
  
  def ensure_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
  end
  
  def ensure_team_leader_or_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user&.admin? || current_user&.team_leader?
  end
end
