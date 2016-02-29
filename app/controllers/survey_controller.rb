class SurveyController < ApplicationController
  before_action :authenticate_thinker!

  before_action :set_sprint
  before_action :not_actual!
  before_action :set_project

  def index
    redirect_to new_sprint_survey_path(@sprint) if current_thinker.answers.where(sprint: @sprint).empty?

    @answers_count   = AnswerThinker.where(sprint: @sprint).group(:answer_id).count
    @answers_thinker = AnswerThinker.where(sprint: @sprint).where(thinker: current_thinker)
    @surveys         = Survey.all
  end

  def create
    @answers = params[:survey]

    @answers.each do |answer|
      AnswerThinker.create(answer_id: answer.last, sprint_id: params[:sprint_id], thinker_id: current_thinker.id)
    end

    respond_to do |format|
      format.html { redirect_to sprint_survey_index_path }
    end
  end

  def new
    @surveys = Survey.all
    @survey  = Survey.new
  end

  private

  def set_project
    @project = @sprint.project
  end

  def set_sprint
    @sprint = Sprint.find(params[:sprint_id])
  end

  def not_actual!
    redirect_to project_sprints_path(@sprint.project) if @sprint.serial == @sprint.project.sprint
  end

  def survey_params
    # allowed_params = Survey.all.map(&:id)

    params.require(:survey) # .permit(allowed_params)
  end
end
