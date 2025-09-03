class Dashboard::DashboardController < ApplicationController
  before_action :authenticate_user!

  # Common dashboard functionality
  protected

  def set_dashboard_data
    @total_documents = Document.count
    @total_folders = Folder.count
    @total_tags = Tag.count
  end

  def set_recent_activity
    @recent_activity = Activity.includes(:user, :document)
                              .order(created_at: :desc)
                              .limit(10)
  end

  def set_user_stats(user)
    {
      total_documents: user.authored_documents.count,
      total_teams: user.teams.count,
      led_teams: user.led_teams.count,
      pending_documents: user.authored_documents.joins(:status).where(statuses: { name: "Pending" }).count
    }
  end

  def set_system_stats
    {
      total_users: User.count,
      total_organizations: Organization.count,
      total_teams: Team.count,
      total_documents: Document.count,
      total_folders: Folder.count,
      total_tags: Tag.count
    }
  end
end
