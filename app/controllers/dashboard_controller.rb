class DashboardController < ApplicationController
  def index
    @recent_documents = current_user.authored_documents.recent.limit(5)
    @my_teams = current_user.teams.includes(:organization)
    @led_teams = current_user.led_teams.includes(:organization)
    @recent_activity = Activity.joins(:document)
                              .where(documents: { author: current_user })
                              .or(Activity.where(user: current_user))
                              .recent
                              .limit(10)
                              .includes(:document, :user, :old_status, :new_status)
    
    # Statistics
    @stats = {
      total_documents: current_user.authored_documents.count,
      total_teams: @my_teams.count,
      led_teams: @led_teams.count,
      pending_documents: current_user.authored_documents.joins(:status).where(statuses: { name: 'Pending' }).count
    }
  end
end
