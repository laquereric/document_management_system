class Models::TagsController < Models::ModelsController
  before_action :set_tag, only: [ :show, :edit, :update, :destroy ]

  def index
    @q = Tag.ransack(params[:q])
    @tags = @q.result(distinct: true)
               .includes(:organization, :team, :folder)
               .order(created_at: :desc)
               .page(params[:page])
               .per(20)

    # Filter tags based on user permissions
    if current_user.admin?
      # Admin sees all tags
      @tags = @tags
    elsif params[:user_id].present?
      # If viewing specific user's tags, check permissions
      user = User.find(params[:user_id])
      if current_user == user || current_user.admin?
        # Get tags that are associated with documents by this user
        user_document_ids = Document.where(author: user).pluck(:id)
        @tags = @tags.joins(:taggings).where(taggings: { taggable_type: "Document", taggable_id: user_document_ids }).distinct
      else
        # Regular users can only see tags on their own documents
        current_user_document_ids = Document.where(author: current_user).pluck(:id)
        @tags = @tags.joins(:taggings).where(taggings: { taggable_type: "Document", taggable_id: current_user_document_ids }).distinct
      end
    else
      # Regular users see only tags on their own documents
      current_user_document_ids = Document.where(author: current_user).pluck(:id)
      @tags = @tags.joins(:taggings).where(taggings: { taggable_type: "Document", taggable_id: current_user_document_ids }).distinct
    end
  end



  def show
    # Get documents with this tag using a proper ActiveRecord query
    @documents = Document.joins(:taggings)
                         .where(taggings: { tag_id: @tag.id })
                         .includes(:author, :folder, :status, :tags)
                         .page(params[:page])
                         .per(20)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to models_tag_path(@tag), notice: "Tag was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to models_tag_path(@tag), notice: "Tag was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    tag_name = @tag.name
    if @tag.destroy
      redirect_to models_tags_path, notice: "Tag was successfully deleted."
    else
      redirect_to models_tag_path(@tag), alert: "Failed to delete tag."
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
      redirect_to root_path, alert: "Access denied. Admin privileges required."
    end
  end
end
