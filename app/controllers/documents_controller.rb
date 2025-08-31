class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy, :change_status, :add_tag, :remove_tag]
  before_action :set_folder, only: [:new, :create]
  before_action :ensure_user_can_access_document, only: [:show, :edit, :update, :destroy]
  
  def index
    @q = Document.ransack(params[:q])
    @documents = @q.result.includes(:author, :folder, :status, :tags, :scenario)
                   .page(params[:page])
                   .per(20)
    
    # Apply sorting
    case params[:sort]
    when 'title'
      @documents = @documents.order(:title)
    when 'status'
      @documents = @documents.joins(:status).order('statuses.name')
    else
      @documents = @documents.order(created_at: :desc)
    end
    
    # Filter by user's accessible documents
    unless current_user.admin?
      team_ids = current_user.teams.pluck(:id)
      @documents = @documents.joins(folder: :team).where(teams: { id: team_ids })
    end
  end

  def show
    @activities = @document.activities.recent.includes(:user, :old_status, :new_status)
  end

  def new
    @document = @folder ? @folder.documents.build : Document.new
    @statuses = Status.all
    @scenarios = Scenario.all
  end

  def create
    @document = @folder ? @folder.documents.build(document_params) : Document.new(document_params)
    @document.author = current_user
    
    if @document.save
      ActivityLog.create!(
        document: @document,
        user: current_user,
        action: 'created',
        notes: 'Document created'
      )
      redirect_to @document, notice: 'Document was successfully created.'
    else
      @statuses = Status.all
      @scenarios = Scenario.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @statuses = Status.all
    @scenarios = Scenario.all
  end

  def update
    if @document.update(document_params)
      ActivityLog.create!(
        document: @document,
        user: current_user,
        action: 'updated',
        notes: 'Document updated'
      )
      redirect_to @document, notice: 'Document was successfully updated.'
    else
      @statuses = Status.all
      @scenarios = Scenario.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    document_title = @document.title
    if @document.destroy
      ActivityLog.create!(
        user: current_user,
        action: 'deleted',
        notes: "Deleted document: #{document_title}"
      )
      redirect_to documents_url, notice: 'Document was successfully deleted.'
    else
      redirect_to @document, alert: 'Failed to delete document.'
    end
  end

  def change_status
    new_status = Status.find(params[:status_id])
    old_status = @document.status
    
    if @document.update(status: new_status)
      ActivityLog.create!(
        document: @document,
        user: current_user,
        action: 'status_change',
        old_status: old_status,
        new_status: new_status,
        notes: params[:notes]
      )
      redirect_to @document, notice: 'Status updated successfully.'
    else
      redirect_to @document, alert: 'Failed to update status.'
    end
  end

  def add_tag
    tag = Tag.find(params[:tag_id])
    unless @document.tags.include?(tag)
      @document.tags << tag
      ActivityLog.create!(
        document: @document,
        user: current_user,
        action: 'tag_added',
        notes: "Added tag: #{tag.name}"
      )
    end
    redirect_to @document
  end

  def remove_tag
    tag = Tag.find(params[:tag_id])
    @document.tags.delete(tag)
    ActivityLog.create!(
      document: @document,
      user: current_user,
      action: 'tag_removed',
      notes: "Removed tag: #{tag.name}"
    )
    redirect_to @document
  end

  def search
    @q = Document.ransack(params[:q])
    @documents = @q.result.includes(:author, :folder, :status, :tags)
    
    # Filter by user's accessible documents
    unless current_user.admin?
      team_ids = current_user.teams.pluck(:id)
      @documents = @documents.joins(folder: :team).where(teams: { id: team_ids })
    end
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def set_folder
    @folder = Folder.find(params[:folder_id]) if params[:folder_id]
  end

  def ensure_user_can_access_document
    unless current_user.admin? || @document.team.members.include?(current_user)
      redirect_to documents_path, alert: 'You do not have permission to access this document.'
    end
  end

  def document_params
    params.require(:document).permit(:title, :url, :content, :status_id, :scenario_id, :folder_id, :file)
  end
end
