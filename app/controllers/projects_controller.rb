class ProjectsController < ApplicationController
  include ProjectsHelper

  before_action :set_project, only: [:show, :edit, :update, :destroy, :partecipate, :team, :tasks]
  before_action :authenticate_thinker!, except: [:index, :show]

  # GET /projects
  # GET /projects.json
  def index
    @filterrific = initialize_filterrific(
      Project,
      params[:filterrific],
      select_options: {
        sorted_by: Project.options_for_sorted_by
      },
    ) or return
    @projects = @filterrific.find.page params[:page]

    respond_to do |format|
      format.html
      format.js
    end
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new

    @project.description = "## Put here your short description, will be used for index your project \n\nDescribe your project, and remember, you can use MARKDOWN!"
  end

  # GET /projects/1/edit
  def edit
    unless creator?(@project.thinker.id)
      flash[:warning] = t(:cant_edit)
      redirect_to project_path(@project)
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.thinker_id = current_thinker.id

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        set_form_errors(@project)
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      unless creator?(@project.thinker.id)
        format.html { redirect_to project_path(@project), error: t(:cant_update) }
      end

      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    respond_to do |format|
      unless creator?(@project.thinker.id)
        format.html { redirect_to project_path(@project), error: t(:wtf_are_you_destroying) }
      end
    
      @project.destroy
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /projects/1/partecipate
  # PATCH/PUT /projects/1/partecipate.json
  def partecipate
    respond_to do |format|
      unless creator?(@project.thinker.id)
        format.html { redirect_to project_path(@project), warning: t(:wtf_the_creator_partecipate) }
      end
  
      @project.thinkers << current_thinker
      format.html { redirect_to project_path(@project), notice: 'Now you are an active member of the team! Congratz ;-)' }
    end
  end

  # GET /projects/1/team
  # GET /projects/1/team.json
  def team
    @team = @project.thinkers
  end

  # GET /projects/1/tasks
  # GET /projects/1/tasks.json
  # def tasks
  #   @statuses = Status.all
  #   @tasks    = @project.tasks
  # end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:id])

      load_project_session
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :minimum_team_number, :release_at, :license_id, :source_code_url, :home_url, :documentation_url, :cycle_id, :category_id)
    end
end
