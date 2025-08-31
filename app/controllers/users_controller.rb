class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_user_can_access_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_user_can_manage_users, only: [:new, :create, :destroy]
  
  def index
    @q = User.ransack(params[:q])
    @users = @q.result.includes(:organization, :teams)
                .page(params[:page])
                .per(20)
    
    # Filter by user's accessible users
    unless current_user.admin?
      @users = @users.where(organization_id: current_user.organization_id)
    end
  end

  def show
    @authored_documents = @user.authored_documents.includes(:folder, :status, :tags)
                               .page(params[:page])
                               .per(10)
    @activities = @user.activities.includes(:document)
                          .recent
                          .page(params[:page])
                          .per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user_name = @user.name
    if @user.destroy
      redirect_to users_url, notice: 'User was successfully deleted.'
    else
      redirect_to @user, alert: 'Failed to delete user.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_user_can_access_user
    unless current_user.admin? || @user.organization_id == current_user.organization_id
      redirect_to users_path, alert: 'You do not have permission to access this user.'
    end
  end

  def ensure_user_can_manage_users
    unless current_user.admin?
      redirect_to users_path, alert: 'You do not have permission to manage users.'
    end
  end

  def user_params
    permitted_params = [:name, :email, :role, :organization_id]
    permitted_params << :password << :password_confirmation if params[:user][:password].present?
    params.require(:user).permit(permitted_params)
  end
end
