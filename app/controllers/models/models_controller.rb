class Models::ModelsController < ApplicationController
  before_action :authenticate_user!

  # Common functionality for all models controllers
  protected

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied. Admin privileges required."
    end
  end

  def ensure_user_can_access_resource(resource)
    unless current_user.admin? || resource.respond_to?(:team) && resource.team.members.include?(current_user)
      redirect_to root_path, alert: "You do not have permission to access this resource."
    end
  end

  def ensure_user_can_manage_resource(resource)
    unless current_user.admin?
      redirect_to root_path, alert: "You do not have permission to manage this resource."
    end
  end

  def set_pagination
    @page = params[:page] || 1
    @per_page = params[:per_page] || 20
  end

  def set_search
    @q = nil
    if params[:q].present?
      @q = controller_name.classify.constantize.ransack(params[:q])
    end
  end
end
