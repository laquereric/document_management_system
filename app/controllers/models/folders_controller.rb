class Models::FoldersController < Models::ModelsController
  before_action :set_folder, only: [:show, :edit, :update, :destroy, :contents]
  before_action :ensure_user_can_access_folder, only: [:show, :edit, :update, :destroy, :contents]
  
  def index
    @q = Folder.ransack(params[:q])
    @folders = @q.result.includes(:team, :parent_folder, :documents)
                  .page(params[:page])
                  .per(20)
    
    # Filter by user's accessible folders
    unless current_user.admin?
      team_ids = current_user.teams.pluck(:id)
      @folders = @folders.where(team_id: team_ids)
    end
  end

  def show
    @documents = @folder.documents.includes(:author, :status, :tags)
                       .page(params[:page])
                       .per(20)
    @subfolders = @folder.subfolders.includes(:documents)
  end

  def new
    @folder = Folder.new
  end

  def create
    @folder = Folder.new(folder_params)
    
    if @folder.save
      redirect_to @folder, notice: 'Folder was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @folder.update(folder_params)
      redirect_to @folder, notice: 'Folder was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    folder_name = @folder.name
    if @folder.destroy
      redirect_to models_folders_path, notice: 'Folder was successfully deleted.'
    else
      redirect_to @folder, alert: 'Failed to delete folder.'
    end
  end

  def contents
    @documents = @folder.documents.includes(:author, :status, :tags)
                       .page(params[:page])
                       .per(20)
    @subfolders = @folder.subfolders.includes(:documents)
  end

  private

  def set_folder
    @folder = Folder.find(params[:id])
  end

  def ensure_user_can_access_folder
    unless current_user.admin? || @folder.team.members.include?(current_user)
      redirect_to models_folders_path, alert: 'You do not have permission to access this folder.'
    end
  end

  def folder_params
    params.require(:folder).permit(:name, :description, :team_id, :parent_folder_id)
  end
end
