class Admin::ScenarioTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_scenario_type, only: [:show, :edit, :update, :destroy]

  def index
    @q = ScenarioType.ransack(params[:q])
    @scenario_types = @q.result(distinct: true)
                        .includes(:documents)
                        .order(created_at: :desc)
                        .page(params[:page])
                        .per(20)
  end

  def show
    @documents = @scenario_type.documents.includes(:author, :folder, :status, :tags)
                               .page(params[:page])
                               .per(20)
  end

  def new
    @scenario_type = ScenarioType.new
  end

  def create
    @scenario_type = ScenarioType.new(scenario_type_params)
    
    if @scenario_type.save
      redirect_to admin_scenario_type_path(@scenario_type), notice: 'Scenario type was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @scenario_type.update(scenario_type_params)
      redirect_to admin_scenario_type_path(@scenario_type), notice: 'Scenario type was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    scenario_type_name = @scenario_type.name
    if @scenario_type.destroy
      redirect_to admin_scenario_types_path, notice: 'Scenario type was successfully deleted.'
    else
      redirect_to admin_scenario_type_path(@scenario_type), alert: 'Failed to delete scenario type. It may be in use by documents.'
    end
  end

  private

  def set_scenario_type
    @scenario_type = ScenarioType.find(params[:id])
  end

  def scenario_type_params
    params.require(:scenario_type).permit(:name, :description)
  end

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end
