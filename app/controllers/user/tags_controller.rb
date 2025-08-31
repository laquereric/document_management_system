class User::TagsController < ApplicationController
  before_action :set_user
  
  def index
    @tags = @user.authored_documents.joins(:tags)
                  .select('tags.*, COUNT(documents.id) as document_count')
                  .group('tags.id')
                  .page(params[:page])
                  .per(20)
  end

  def show
    @tag = Tag.find(params[:id])
    @documents = @user.authored_documents.joins(:tags)
                      .where(tags: { id: @tag.id })
                      .page(params[:page])
                      .per(20)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
