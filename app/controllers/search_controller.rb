class SearchController < ApplicationController
  # No authentication required in authentication-free environment

  def index
    @q = Document.ransack(params[:q])
    @documents = @q.result.includes(:author, :folder, :status, :tags)
                   .page(params[:page])
                   .per(20)

    # Filter by user's accessible documents
    unless current_user.admin?
      team_ids = current_user.teams.pluck(:id)
      @documents = @documents.joins(folder: :team).where(teams: { id: team_ids })
    end
  end
end
