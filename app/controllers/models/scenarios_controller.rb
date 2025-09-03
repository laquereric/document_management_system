class Models::ScenariosController < Models::ModelsController

  before_action :set_scenario, only: [:show, :edit, :update, :destroy]

  def index
    @q = Scenario.ransack(params[:q])
    @scenarios = @q.result(distinct: true)
                   .includes(:documents)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(20)
  end

  def show
    @documents = @scenario.documents.includes(:author, :folder, :status, :tags)
                         .page(params[:page])
                         .per(20)
  end

  def new
    @scenario = Scenario.new
  end

  def create
    @scenario = Scenario.new(scenario_params)
    
    if @scenario.save
      redirect_to models_scenario_path(@scenario), notice: 'Scenario was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @scenario.update(scenario_params)
      redirect_to models_scenario_path(@scenario), notice: 'Scenario was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @scenario.destroy
      redirect_to models_scenarios_path, notice: 'Scenario was successfully deleted.'
    else
      redirect_to models_scenario_path(@scenario), alert: 'Failed to delete scenario. It may be in use by documents.'
    end
  end

  private

  def set_scenario
    @scenario = Scenario.find(params[:id])
  end

  def scenario_params
    params.require(:scenario).permit(:name, :description)
  end


end
