class User::FoldersController < ApplicationController
  before_action :set_user
  before_action :set_folder, only: [:show, :edit, :update, :destroy, :contents]
  
  def index
    @folders = @user.owned_folders.includes(:parent, :documents)
                   .page(params[:page])
                   .per(20)
  end

  def show
    # Folder is already loaded via set_folder
  end

  def new
    @folder = @user.owned_folders.build
  end

  def create
    @folder = @user.owned_folders.build(folder_params)
    
    if @folder.save
      redirect_to user_folder_path(@user, @folder), notice: 'Folder was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Folder is already loaded via set_folder
  end

  def update
    if @folder.update(folder_params)
      redirect_to user_folder_path(@user, @folder), notice: 'Folder was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @folder.destroy
    redirect_to user_folders_path(@user), notice: 'Folder was successfully deleted.'
  end

  def contents
    @documents = @folder.documents.includes(:tags, :status)
                       .page(params[:page])
                       .per(20)
    @subfolders = @folder.children.includes(:documents)
    
    render :show
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_folder
    @folder = @user.owned_folders.find(params[:id])
  end

  def folder_params
    params.require(:folder).permit(:name, :description, :parent_id)
  end
end
