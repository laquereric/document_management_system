class ActivitiesController < ApplicationController
  before_action :set_user, only: [:index, :show]
  before_action :set_activity, only: [:show]
  
  def index
    @q = Activity.ransack(params[:q])
    @activities = @q.result.includes(:document, :user, :old_status, :new_status)
                    .page(params[:page])
                    .per(20)
    
    # Filter by user's accessible activities
    unless current_user.admin?
      @activities = @activities.where(
        'activities.user_id = ? OR documents.author_id = ?', 
        current_user.id, 
        current_user.id
      ).joins(:document)
    end
  end

  def show
    # Ensure user can access this activity
    unless current_user.admin? || @activity.user == current_user || @activity.document.author == current_user
      redirect_to activities_path, alert: 'You do not have permission to view this activity.'
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_activity
    @activity = Activity.find(params[:id])
  end
end
