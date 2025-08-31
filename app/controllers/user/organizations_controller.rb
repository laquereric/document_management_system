class User::OrganizationsController < ApplicationController
  before_action :set_user
  
  def index
    @organizations = @user.teams.joins(:organization)
                          .select('organizations.*, COUNT(teams.id) as team_count')
                          .group('organizations.id')
                          .page(params[:page])
                          .per(20)
  end

  def show
    @organization = Organization.find(params[:id])
    @teams = @user.teams.where(organization: @organization)
                  .includes(:organization)
                  .page(params[:page])
                  .per(20)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
