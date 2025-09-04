class Models::UsersController < Models::ModelsController
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :toggle_role ]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
               .includes(:organization, :teams)
               .order(created_at: :desc)
               .page(params[:page])
               .per(20)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to models_user_path(@user), notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to models_user_path(@user), notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to models_users_path, alert: "You cannot delete your own account."
    elsif @user.destroy
      redirect_to models_users_path, notice: "User was successfully deleted."
    else
      redirect_to models_user_path(@user), alert: "Failed to delete user."
    end
  end

  def toggle_role
    new_role = @user.admin? ? "user" : "admin"
    if @user.update(role: new_role)
      redirect_to models_user_path(@user), notice: "User role changed to #{new_role}."
    else
      redirect_to models_user_path(@user), alert: "Failed to change user role."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    # Only allow role changes for admins
    # No password attributes in authentication-free environment
    permitted_params = [ :name, :email, :organization_id ]
    permitted_params << :role if current_user&.admin?
    params.require(:user).permit(permitted_params)
  end
end
