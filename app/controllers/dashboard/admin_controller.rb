class Dashboard::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @total_users = User.count
    @total_organizations = Organization.count
    @total_teams = Team.count
    @total_documents = Document.count
    @total_folders = Folder.count
    @total_tags = Tag.count
    
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_documents = Document.includes(:author, :team).order(created_at: :desc).limit(5)
    @recent_activity = Activity.includes(:user, :document).order(created_at: :desc).limit(10)
    
    @users_by_role = User.group(:role).count
    @documents_by_status = Document.joins(:status).group('statuses.name').count
  end

  private

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end
