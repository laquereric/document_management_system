class Models::OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :ensure_user_can_access_organization, only: [:show, :edit, :update, :destroy]
  
  def index
    @q = Organization.ransack(params[:q])
    @organizations = @q.result.includes(:users, :teams)
                       .page(params[:page])
                       .per(20)
    
    # Filter by user's accessible organizations
    unless current_user.admin?
      @organizations = @organizations.where(id: current_user.organization_id)
    end
  end

  def show
    @teams = @organization.teams.includes(:leader, :members)
    @users = @organization.users.includes(:teams)
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    
    if @organization.save
      # Assign current user to the organization if they don't have one
      if current_user.organization_id.nil?
        current_user.update(organization: @organization)
      end
      
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    organization_name = @organization.name
    if @organization.destroy
      redirect_to organizations_url, notice: 'Organization was successfully deleted.'
    else
      redirect_to @organization, alert: 'Failed to delete organization.'
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def ensure_user_can_access_organization
    unless current_user.admin? || @organization.id == current_user.organization_id
      redirect_to organizations_path, alert: 'You do not have permission to access this organization.'
    end
  end

  def organization_params
    params.require(:organization).permit(:name, :description)
  end
end
