class User::DocumentsController < ApplicationController
  before_action :set_user
  before_action :set_document, only: [:show, :edit, :update, :destroy, :change_status, :add_tag, :remove_tag]
  
  def index
    @q = @user.authored_documents.ransack(params[:q])
    @documents = @q.result.includes(:tags, :status, :folder)
                   .page(params[:page])
                   .per(20)
  end

  def show
    # Document is already loaded via set_document
  end

  def new
    @document = @user.authored_documents.build
  end

  def create
    @document = @user.authored_documents.build(document_params)
    
    if @document.save
      redirect_to user_document_path(@user, @document), notice: 'Document was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Document is already loaded via set_document
  end

  def update
    if @document.update(document_params)
      redirect_to user_document_path(@user, @document), notice: 'Document was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to user_documents_path(@user), notice: 'Document was successfully deleted.'
  end

  def change_status
    new_status = Status.find(params[:status_id])
    old_status = @document.status
    
    if @document.update(status: new_status)
      # Log the status change
      @user.activities.create!(
        document: @document,
        action: 'status_change',
        old_status: old_status,
        new_status: new_status,
        notes: "Status changed from #{old_status&.name} to #{new_status.name}"
      )
      
      redirect_to user_document_path(@user, @document), notice: 'Document status was successfully updated.'
    else
      redirect_to user_document_path(@user, @document), alert: 'Failed to update document status.'
    end
  end

  def add_tag
    tag = Tag.find(params[:tag_id])
    
    unless @document.tags.include?(tag)
      @document.tags << tag
      @user.activities.create!(
        document: @document,
        action: 'tag_added',
        notes: "Added tag: #{tag.name}"
      )
      redirect_to user_document_path(@user, @document), notice: 'Tag was successfully added.'
    else
      redirect_to user_document_path(@user, @document), alert: 'Document already has this tag.'
    end
  end

  def remove_tag
    tag = Tag.find(params[:tag_id])
    
    if @document.tags.include?(tag)
      @document.tags.delete(tag)
      @user.activities.create!(
        document: @document,
        action: 'tag_removed',
        notes: "Removed tag: #{tag.name}"
      )
      redirect_to user_document_path(@user, @document), notice: 'Tag was successfully removed.'
    else
      redirect_to user_document_path(@user, @document), alert: 'Document does not have this tag.'
    end
  end

  def search
    @q = @user.authored_documents.ransack(params[:q])
    @documents = @q.result.includes(:tags, :status, :folder)
                   .page(params[:page])
                   .per(20)
    
    render :index
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_document
    @document = @user.authored_documents.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :content, :folder_id, :status_id, tag_ids: [])
  end
end
