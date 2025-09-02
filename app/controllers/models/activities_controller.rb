class Models::ActivitiesController < Models::ModelsController
  before_action :set_activity, only: [:show]
  
  def index
    @q = Activity.ransack(params[:q])
    @activities = @q.result.includes(:document, :user, :old_status, :new_status)
                    .page(params[:page])
                    .per(20)
    
    # Filter by user's accessible activities based on permissions
    if current_user.admin?
      # Admin sees all activities
      @activities = @activities
    elsif params[:user_id].present?
      # If viewing specific user's activities, check permissions
      user = User.find(params[:user_id])
      if current_user == user || current_user.admin?
        @activities = @activities.where(user: user)
      else
        # Regular users can only see their own activities or activities on their documents
        @activities = @activities.where(
          'activities.user_id = ? OR documents.author_id = ?', 
          current_user.id, 
          current_user.id
        ).joins(:document)
      end
    else
      # Regular users see only their own activities or activities on their documents
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
      redirect_to models_activities_path, alert: 'You do not have permission to view this activity.'
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end
end
