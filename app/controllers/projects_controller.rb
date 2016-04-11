class ProjectsController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_thinker!, except: [:index, :show]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :contribute, :team, :tasks]
  before_action :thinker!, only: [:edit, :update]

  # GET /projects
  # GET /projects.json
  def index
    @filterrific = initialize_filterrific(
      Project,
      params[:filterrific],
      select_options: {
        sorted_by: Project.options_for_sorted_by
      }
    ) || return
    @projects = @filterrific.find.page params[:page]

    respond_to do |format|
      if Project.all.empty?
        format.html { redirect_to new_project_path, notice: 'You are the first one! Create the first project and share what you think!' }
      end

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
    @contribution = Contribution
                    .where(thinker: current_thinker)
                    .where(project: @project)
                    .first_or_initialize
  end

  # GET /projects/new
  def new
    @project = Project.new

    @project.description = "*Put here your short description, will be used for index your project* \n\nDescribe your project, and remember, you can use MARKDOWN!"
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.thinker = current_thinker

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
      if @project.started?
        if @project.release_at != project_params[:release_at]
          format.html { redirect_to project_path(@project), error: t(:cant_update_release_at) }
          format.json { render json: @project.errors, status: :cant_update_release_at }
        end
      end

      if @project.update(project_params)
        create_notification(@project, @project)
        format.html { redirect_to project_path(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        set_form_errors(@project)

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
      create_notification(@project, @project)
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /projects/1/contribute
  # PATCH/PUT /projects/1/contribute.json
  def contribute
    respond_to do |format|
      @contribution           = Contribution.where(thinker: current_thinker)
                                            .where(project: @project)
                                            .first_or_create
      @contribution.intensity = params[:contribution][:intensity]
      @contribution.save

      create_notification(@project, @project)
      format.html { redirect_to project_path(@project), notice: 'Your contribution has been saved!' }
    end
  end

  # GET /projects/1/team
  # GET /projects/1/team.json
  def team
    @team = @project.team
    @team.map!(&:thinker)
  end

  # GET /projects/1/tasks
  # GET /projects/1/tasks.json
  # def tasks
  #   @statuses = Status.all
  #   @tasks    = @project.tasks
  # end

  # PATCH/PUT /notifications/1/read_all
  # PATCH/PUT /notifications/1/read_all.json
  def read_all
    @project       = Project.friendly.find(params[:project_id])
    @notifications = Notification.where(project: @project)

    current_thinker.notifications << @notifications
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'All notifications read.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.friendly.find(params[:id])

    load_project_session
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:title, :description, :minimum_team_number, :release_at, :license_id, :source_code_url, :home_url, :documentation_url, :cycle_id, :category_id, :main_image)
  end
end
