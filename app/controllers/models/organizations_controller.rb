class Models::OrganizationsController < Models::ModelsController

  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:user_organizations]

  def index
    @organizations = Organization.includes(:users, :teams).order(created_at: :desc)
  end

  def user_organizations
    @organizations = @user.teams.joins(:organization)
                          .includes(:users, :teams)
                          .distinct
                          .order(created_at: :desc)
                          .page(params[:page])
                          .per(20)
    
    render :user_organizations
  end

  def show
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    
    if @organization.save
      redirect_to admin_organization_path(@organization), notice: 'Organization was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @organization.update(organization_params)
      redirect_to admin_organization_path(@organization), notice: 'Organization was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization.destroy
    redirect_to admin_organizations_path, notice: 'Organization was successfully deleted.'
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def organization_params
    params.require(:organization).permit(:name, :description, :website, :address)
  end

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end
