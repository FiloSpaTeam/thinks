class GoalsController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_action :set_goal, only: [:show, :edit, :update, :destroy, :tasks_in_sprint]
  before_action :set_project, only: [:new, :index, :create]
  before_action :set_validators_for_form_help, only: [:new, :edit]

  before_action :authenticate_thinker!

  # GET /goals
  # GET /goals.json
  def index
    @filterrific = initialize_filterrific(
      Goal .where(project: @project)
      .order('progress DESC') .order('created_at DESC'),
      params[:filterrific],
      select_options: {}
    ) || return
    @goals = @filterrific.find.page(params[:page])
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  # GET /goals/1
  # GET /goals/1.json
  def show
    @project = @goal.project
  end

  # GET /goals/new
  def new
    @goal         = Goal.new

    @project_form = @project
  end

  # GET /goals/1/edit
  def edit
    @project_form = nil
    @project      = @goal.project
    if current_thinker != @goal.thinker
      respond_to do |format|
        format.html { redirect_to @goal, alert: 'You cannot edit this.' }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /goals
  # POST /goals.json
  def create
    @goal          = Goal.new(goal_params)
    @goal.project  = @project
    @goal.thinker  = current_thinker
    @goal.progress = 0.0

    respond_to do |format|
      if @goal.save && create_notification(@goal)
        format.html { redirect_to @goal, notice: 'Goal was successfully created.' }
        format.json { render :show, status: :created, location: @goal }
      else
        set_form_errors(@goal)
        set_validators_for_form_help

        format.html { render :new }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goals/1
  # PATCH/PUT /goals/1.json
  def update
    respond_to do |format|
      if current_thinker == @goal.thinker && @goal.update(goal_params) && create_notification(@goal)
        format.html { redirect_to @goal, notice: 'Goal was successfully updated.' }
        format.json { render :show, status: :ok, location: @goal }
      else
        set_form_errors(@goal)
        set_validators_for_form_help

        format.html { render :edit }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.json
  def destroy
    respond_to do |format|
      if current_thinker == @goal.thinker
        @goal.destroy
        format.html { redirect_to goals_url, notice: 'Goal was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @goal, alert: 'You cannot destroy this goal!' }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  def tasks_in_sprint
    tasks_ready      = @goal.tasks.ready_to_sprint
    n_of_tasks_ready = tasks_ready.count

    respond_to do |format|
      unless n_of_tasks_ready > 0
        format.html { redirect_to goal_path(@goal), alert: "No task can be put in Sprint! Check out some and analize with your team!" }
      end

      tasks_ready.update_all(status_id: Status.sprint.first)

      format.html { redirect_to project_goals_path(@goal.project), notice: pluralize(n_of_tasks_ready, "task") + ' was successfully get in sprint!' }
      format.json { head :no_content }
    end
  end

  private
    def set_validators_for_form_help
      title_validators = Goal.validators_on(:title)[0]
      @chars_max_title = title_validators.options[:maximum]

      title_validators = Goal.validators_on(:description)[0]
      @chars_min_description = title_validators.options[:minimum]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def goal_params
      params[:goal].permit(:title, :description)
    end
end
