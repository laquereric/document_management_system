class Models::TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :ensure_user_can_manage_tags, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @q = Tag.ransack(params[:q])
    @tags = @q.result.includes(:documents)
               .page(params[:page])
               .per(20)
  end

  def show
    @documents = @tag.documents.includes(:author, :folder, :status, :tags)
                    .page(params[:page])
                    .per(20)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    
    if @tag.save
      redirect_to @tag, notice: 'Tag was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to @tag, notice: 'Tag was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    tag_name = @tag.name
    if @tag.destroy
      redirect_to tags_url, notice: 'Tag was successfully deleted.'
    else
      redirect_to @tag, alert: 'Failed to delete tag.'
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def ensure_user_can_manage_tags
    unless current_user.admin?
      redirect_to tags_path, alert: 'You do not have permission to manage tags.'
    end
  end

  def tag_params
    params.require(:tag).permit(:name, :color)
  end
end
