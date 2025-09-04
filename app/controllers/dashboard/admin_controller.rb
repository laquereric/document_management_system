module Dashboard
  class AdminController < Dashboard::DashboardController
  before_action :require_admin!

  def index
    @stats = set_system_stats
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_documents = Document.includes(:author, :folder).order(created_at: :desc).limit(5)
    @recent_activity = set_recent_activity

    @users_by_role = User.group(:role).count
    @documents_by_status = Document.joins(:status).group("statuses.name").count
  end

  private

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied. Admin privileges required."
    end
  end
end
end
