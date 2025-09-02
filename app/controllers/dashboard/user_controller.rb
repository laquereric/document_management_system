class Dashboard::UserController < Dashboard::DashboardController
  before_action :set_user, only: [:index]
  
  def index
    @recent_documents = @user.authored_documents.recent.limit(5)
    @my_teams = @user.teams.includes(:organization)
    @led_teams = @user.led_teams.includes(:organization)
    @recent_activity = Activity.joins(:document)
                              .where(documents: { author: @user })
                              .or(Activity.where(user: @user))
                              .recent
                              .limit(10)
                              .includes(:document, :user, :old_status, :new_status)
    
    # Statistics
    @stats = set_user_stats(@user)
  end

  private

  def set_user
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
  end
end
