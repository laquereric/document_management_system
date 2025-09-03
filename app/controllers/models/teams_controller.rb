class Models::TeamsController < Models::ModelsController

  before_action :set_team, only: [:show, :edit, :update, :destroy, :add_member, :remove_member]

  def index
    @q = Team.ransack(params[:q])
    @teams = @q.result(distinct: true)
               .includes(:organization, :leader, :users)
               .order(created_at: :desc)
               .page(params[:page])
               .per(20)
    
    # Filter teams based on user permissions
    if current_user.admin?
      # Admin sees all teams
      @teams = @teams
    elsif params[:user_id].present?
      # If viewing specific user's teams, check permissions
      user = User.find(params[:user_id])
      if current_user == user || current_user.admin?
        @teams = @teams.where(id: user.teams.pluck(:id))
      else
        # Regular users can only see teams they belong to
        @teams = @teams.where(id: current_user.teams.pluck(:id))
      end
    else
      # Regular users see only teams they belong to
      @teams = @teams.where(id: current_user.teams.pluck(:id))
    end
  end



  def show
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    
    if @team.save
      redirect_to models_team_path(@team), notice: 'Team was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to models_team_path(@team), notice: 'Team was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @team.destroy
      redirect_to models_teams_path, notice: 'Team was successfully deleted.'
    else
      redirect_to models_team_path(@team), alert: 'Failed to delete team.'
    end
  end

  def add_member
    user = User.find(params[:user_id])
    
    unless @team.users.include?(user)
      @team.users << user
      
      # Redirect based on where the request came from
      if params[:redirect_to_user_profile]
        redirect_to user_path(user), notice: "#{user.name} was added to #{@team.name}."
      else
        redirect_to models_team_path(@team), notice: "#{user.name} was added to the team."
      end
    else
      # Redirect based on where the request came from
      if params[:redirect_to_user_profile]
        redirect_to user_path(user), alert: "#{user.name} is already a member of #{@team.name}."
      else
        redirect_to models_team_path(@team), alert: "#{user.name} is already a member of this team."
      end
    end
  end

  def remove_member
    user = User.find(params[:user_id])
    
    if @team.users.include?(user)
      @team.users.delete(user)
      redirect_to models_team_path(@team), notice: "#{user.name} was removed from the team."
    else
              redirect_to models_team_path(@team), alert: "#{user.name} is not a member of this team."
    end
  end

  def join
    user = User.find(params[:user_id])
    
    if @team.members.include?(user)
      redirect_to models_team_path(@team), alert: "#{user.name} is already a member of this team."
    else
      @team.members << user
      redirect_to models_team_path(@team), notice: "#{user.name} was added to the team."
    end
  end

  def leave
    user = User.find(params[:user_id])
    
    if @team.members.include?(user)
      @team.members.delete(user)
      redirect_to models_team_path(@team), notice: "#{user.name} was removed from the team."
    else
      redirect_to models_team_path(@team), alert: "#{user.name} is not a member of this team."
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :description, :organization_id, :leader_id)
  end

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end
