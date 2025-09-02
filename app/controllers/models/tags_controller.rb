class Models::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @q = Tag.ransack(params[:q])
    @tags = @q.result(distinct: true)
               .includes(:documents)
               .order(created_at: :desc)
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
      redirect_to admin_tag_path(@tag), notice: 'Tag was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to admin_tag_path(@tag), notice: 'Tag was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    tag_name = @tag.name
    if @tag.destroy
      redirect_to admin_tags_path, notice: 'Tag was successfully deleted.'
    else
      redirect_to admin_tag_path(@tag), alert: 'Failed to delete tag.'
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :color)
  end

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end
