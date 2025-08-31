class User::TeamsController < ApplicationController
  before_action :set_user
  
  def index
    @teams = @user.teams.includes(:organization)
                   .page(params[:page])
                   .per(20)
  end

  def show
    @team = @user.teams.find(params[:id])
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
