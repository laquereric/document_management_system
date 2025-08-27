class ActivityLogsController < ApplicationController
  before_action :set_activity_log, only: [:show]
  
  def index
    @q = ActivityLog.ransack(params[:q])
    @activity_logs = @q.result.includes(:document, :user, :old_status, :new_status)
                       .page(params[:page])
                       .per(20)
    
    # Filter by user's accessible activity logs
    unless current_user.admin?
      @activity_logs = @activity_logs.where(
        'activity_logs.user_id = ? OR documents.author_id = ?', 
        current_user.id, 
        current_user.id
      ).joins(:document)
    end
  end

  def show
    # Ensure user can access this activity log
    unless current_user.admin? || @activity_log.user == current_user || @activity_log.document.author == current_user
      redirect_to activity_logs_path, alert: 'You do not have permission to view this activity log.'
    end
  end

  private

  def set_activity_log
    @activity_log = ActivityLog.find(params[:id])
  end
end
